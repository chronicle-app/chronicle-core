require 'tsort'
require 'rdf/turtle'
require 'rdf/reasoner'
require 'sparql'

module Chronicle::Schema::Generators
  # Parses a .ttl file and generate a DAG of classes and their properties
  class RDFParser
    SCHEMA_URI = 'https://schema.chronicle.app/'.freeze

    attr_reader :graph, :properties, :classes

    def initialize(ttl_str)
      @ttl_str = ttl_str
    end

    def parse
      @graph = read_graph_from_ttl(@ttl_str)
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

      def tsort_each_node(&)
        @dependencies.each_key(&)
      end

      def tsort_each_child(node, &)
        @dependencies[node][:dependencies].each(&) if @dependencies[node]
      end
    end

    private

    def build_dag(graph); end

    def all_classes
      @graph.query([nil, RDF.type, RDF::RDFS.Class])
            .map(&:subject)
            .map(&:to_s)
            .map { |s| uri_to_symbolized_name(s) }
    end

    def all_subclasses(class_id, subclasses = [])
      direct_subclasses = @graph.query([nil, RDF::RDFS.subClassOf, RDF::URI.new(id_to_uri(class_id))]).map(&:subject)

      direct_subclasses.each do |subclass|
        subclass_id = uri_to_symbolized_name(subclass)
        subclasses << subclass_id unless subclasses.include?(subclass_id)
        all_subclasses(subclass_id, subclasses)
      end

      subclasses
    end

    def nearest_superclass(class_id)
      result = @graph.query([RDF::URI.new(id_to_uri(class_id)), RDF::RDFS.subClassOf, nil]).map(&:object).map(&:to_s)
      uri_to_symbolized_name(result)
    end

    def all_superclasses(class_id, superclasses = [])
      direct_superclasses = @graph.query([RDF::URI.new(id_to_uri(class_id)), RDF::RDFS.subClassOf, nil]).map(&:object)

      direct_superclasses.each do |superclass|
        superclass_id = uri_to_symbolized_name(superclass)
        superclasses << superclass_id unless superclasses.include?(superclass_id)
        all_superclasses(superclass_id, superclasses)
      end

      superclasses
    end

    def properties_of_class(class_id)
      @properties.select do |property|
        property[:domain].include?(class_id)
      end
    end

    def properties_of_superclasses(class_id)
      properties = properties_of_class(class_id)

      # Get properties of the superclasses
      superclasses = all_superclasses(class_id)
      superclasses.each do |superclass|
        properties.concat(properties_of_class(superclass))
      end

      properties.uniq
    end

    # def gather_properties
    #   properties = @graph.query([nil, RDF.type, RDF::RDFV.Property]).map(&:subject)

    #   properties.map do |property|
    #     property_id = uri_to_symbolized_name(property)

    #     range = @graph.query([
    #       property,
    #       RDF::URI.new("#{SCHEMA_URI}rangeIncludes"),
    #       nil]
    #     ).map(&:object)
    #      .map(&:to_s)
    #      .map{|r| uri_to_symbolized_name(r)}

    #     range_with_subclasses = (range + range.map{|r| all_subclasses(r)}).flatten.uniq

    #     domain = @graph.query([
    #       property,
    #       RDF::URI.new("#{SCHEMA_URI}domainIncludes"),
    #       nil]
    #     ).map(&:object).map(&:to_s).map{|d| uri_to_symbolized_name(d) }

    #     {
    #       id: property_id,
    #       schema_uri: property.to_s,
    #       name_snake_case: camel_to_snake(property_id.to_s).to_sym,
    #       range: range.map{|r| uri_to_symbolized_name(r) },
    #       range_with_subclasses: range_with_subclasses.map{|r| uri_to_symbolized_name(r) },
    #       domain: domain,
    #       is_required: property_required?(property_id),
    #       is_many: property_many?(property_id)
    #     }
    #   end
    # end

    # def gather_class_details
    #   detailed_classes = {}
    #   all_classes.each do |class_id|
    #     detailed_classes[class_id] = build_class_details(class_id)
    #   end

    #   sorted = DependencySorter.new(detailed_classes).tsort.map do |class_uri|
    #     [class_uri, detailed_classes[class_uri]]
    #   end.to_h

    #   sorted
    #   detailed_classes
    # end

    # def build_class_details(class_id)
    #   {
    #     properties: properties_of_superclasses(class_id),
    #     subclasses: all_subclasses(class_id),
    #     superclasses: all_superclasses(class_id),
    #     dependencies:
    #       (
    #         all_superclasses(class_id)
    #         # properties_of_superclasses(class_uri)
    #         #   .map{ |p| p[:range] }.flatten).uniq
    #       )
    #   }
    # end

    # def property_required?(property_id)
    #   get_property_cardinality(property_id).first.positive?
    # end

    # def property_many?(property_id)
    #   get_property_cardinality(property_id).last > 1
    # end

    # def get_property_cardinality(property_id)
    #   min_cardinality = @graph.query([
    #     RDF::URI.new(id_to_uri(property_id)),
    #     RDF::OWL.minCardinality,
    #     nil]
    #   ).map(&:object).first&.to_i

    #   max_cardinality = @graph.query([
    #     RDF::URI.new(id_to_uri(property_id)),
    #     RDF::OWL.maxCardinality,
    #     nil]
    #   ).map(&:object).first&.to_i

    #   [min_cardinality || 0, max_cardinality || 2]
    # end

    def read_graph_from_ttl(ttl_str)
      RDF::Graph.new.from_ttl(ttl_str)
    end

    # def id_to_uri(id)
    #   RDF::URI.new("#{SCHEMA_URI}#{id}")
    # end

    # def uri_to_symbolized_name(uri)
    #   strip_uri(uri).to_sym
    # end

    # def strip_uri(uri)
    #   uri.to_s.gsub(SCHEMA_URI, '')
    # end

    # def camel_to_snake(string)
    #   string.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    # end
  end
end
