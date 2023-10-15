require 'tsort'
require 'rdf/turtle'
require 'rdf/reasoner'
require 'sparql'

module Chronicle::Schema::Generators
  # Parses a .ttl file and generates a hash of class and property details
  # for use in generating models and validators
  class RDFParser
    SCHEMA_URI = 'https://schema.chronicle.app/'.freeze

    attr_reader :graph, :properties, :classes

    def initialize(ttl_str)
      @ttl_str = ttl_str
    end

    def parse
      @graph = read_graph_from_ttl(@ttl_str)
      @properties = gather_properties
      @classes = gather_class_details
      self
    end

    def self.parse_ttl_file(ttl_path)
      ttl_str = File.read(ttl_path)
      p = new(ttl_str)
      p.parse
    end

    # Utility class for sorting classes by their dependencies
    class DependencySorter
      include TSort

      def initialize(dependencies)
        @dependencies = dependencies
      end

      def tsort_each_node(&block)
        @dependencies.each_key(&block)
      end

      def tsort_each_child(node, &block)
        @dependencies[node][:dependencies].each(&block) if @dependencies[node]
      end
    end

    private

    def all_classes
      @graph.query([nil, RDF.type, RDF::RDFS.Class]).map(&:subject).map(&:to_s)
    end

    def all_subclasses(class_uri, subclasses = [])
      direct_subclasses = @graph.query([nil, RDF::RDFS.subClassOf, RDF::URI.new(class_uri)]).map(&:subject)

      direct_subclasses.each do |subclass|
        subclasses << subclass unless subclasses.include?(subclass)
        all_subclasses(subclass, subclasses)
      end

      subclasses.map(&:to_s)
    end

    def nearest_superclass(class_uri)
      @graph.query([RDF::URI.new(class_uri), RDF::RDFS.subClassOf, nil]).map(&:object).map(&:to_s)
    end

    def all_superclasses(class_uri, superclasses = [])
      direct_superclasses = @graph.query([RDF::URI.new(class_uri), RDF::RDFS.subClassOf, nil]).map(&:object)

      direct_superclasses.each do |superclass|
        superclasses << superclass unless superclasses.include?(superclass)
        all_superclasses(superclass, superclasses)
      end

      superclasses.map(&:to_s)
    end

    def properties_of_class(class_uri)
      @properties.select do |property|
        property[:domain].include?(class_uri.to_s)
      end
    end

    def properties_of_superclasses(class_uri)
      properties = properties_of_class(class_uri)

      # Get properties of the superclasses
      superclasses = all_superclasses(class_uri)
      superclasses.each do |superclass|
        properties.concat(properties_of_class(superclass))
      end

      properties.uniq
    end

    def get_property_range(property_uri)
      @graph.query([
        property_uri,
        RDF::URI.new("#{SCHEMA_URI}rangeIncludes"),
        nil]
      ).map(&:object)
       .map{|o| clean_uri(o.to_s)}
    end

    def gather_properties
      properties = @graph.query([nil, RDF.type, RDF::RDFV.Property]).map(&:subject)

      properties.map do |property|
        range = @graph.query([
          property,
          RDF::URI.new("#{SCHEMA_URI}rangeIncludes"),
          nil]
        ).map(&:object).map(&:to_s)

        range_with_subclasses = (range + range.map{|r| all_subclasses(r).map(&:to_s)}).flatten.uniq

        domain = @graph.query([
          property,
          RDF::URI.new("#{SCHEMA_URI}domainIncludes"),
          nil]
        ).map(&:object).map(&:to_s)

        {
          name: property.to_s,
          name_shortened: strip_uri(property.to_s),
          name_snake_case: camel_to_snake(strip_uri(property.to_s)),
          range: range,
          range_with_subclasses: range_with_subclasses,
          domain: domain,
          cardinality: get_property_cardinality(property)
        }
      end
    end

    def gather_class_details
      detailed_classes = {}
      all_classes.each do |class_uri|
        detailed_classes[class_uri.to_s] = build_class_details(class_uri)
      end

      DependencySorter.new(detailed_classes).tsort.map do |class_uri|
        [class_uri, detailed_classes[class_uri]]
      end.to_h
    end

    def build_class_details(class_uri)
      {
        name: class_uri,
        name_short: strip_uri(class_uri),
        properties: properties_of_superclasses(class_uri),
        subclasses: all_subclasses(class_uri),
        superclasses: all_superclasses(class_uri),
        dependencies:
          (nearest_superclass(class_uri).map(&:to_s) +
            properties_of_superclasses(class_uri)
              .map{ |p| p[:range] }.flatten).uniq
      }
    end

    def get_property_cardinality(property)
      min_cardinality = @graph.query([
        property,
        RDF::OWL.minCardinality,
        nil]
      ).map(&:object).first&.to_i

      max_cardinality = @graph.query([
        property,
        RDF::OWL.maxCardinality,
        nil]
      ).map(&:object).first&.to_i

      if min_cardinality == 1 && max_cardinality == 1
        :one
      elsif min_cardinality.nil? && max_cardinality == 1
        :zero_or_one
      elsif min_cardinality == 1 && max_cardinality.nil?
        :one_or_more
      else
      # elsif min_cardinality.nil? && max_cardinality.nil?
        :zero_or_more
      end
    end

    def read_graph_from_ttl(ttl_str)
      RDF::Graph.new.from_ttl(ttl_str)
    end

    def strip_uri(uri)
      uri.to_s.gsub(SCHEMA_URI, '')
    end

    def camel_to_snake(string)
      string.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    end
  end
end
