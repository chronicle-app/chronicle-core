require 'tsort'
require 'rdf/turtle'
require_relative '../schema_graph'
require_relative '../schema_type'
require_relative '../schema_property'

module Chronicle::Schema::RDFParsing
  class TTLGraphBuilder
    attr_reader :ttl_str, :ttl_graph, :graph

    def initialize(ttl_str, default_prefix: 'https://schema.org/')
      @ttl_str = ttl_str
      @default_prefix = default_prefix
      @graph = Chronicle::Schema::SchemaGraph.new
    end

    def build
      reader = RDF::Reader.for(:ttl).new(@ttl_str)
      @ttl_graph = RDF::Graph.new << reader

      @graph.version = get_version
      @graph.classes = build_class_graph
      @graph.properties = build_property_graph
      # build_datatype_graph
      @graph.build_references!
      @graph
    end

    def self.build_from_file(file_path)
      new(File.read(file_path)).build
    end

    def self.build_from_ttl(ttl_str)
      new(ttl_str).build
    end

    private

    # TODO: make this use proper schema
    def get_version
      @ttl_graph.query([nil, RDF::OWL.versionInfo, nil]).map(&:object).map(&:to_s).first
    end

    def build_class_graph
      classes = all_classes.map do |class_id|
        comment = comment_of_class(class_id)
        Chronicle::Schema::SchemaType.new(class_id, comment:, namespace: @default_prefix)
      end

      classes.each do |schema_type|
        schema_type.subclass_ids = subclasses_of_class(schema_type.id)
      end

      classes
    end

    def build_property_graph
      all_properties.map do |property_id|
        property = Chronicle::Schema::SchemaProperty.new(property_id)
        property.range = range_of_property(property_id)
        property.domain = domain_of_property(property_id)
        property.comment = comment_of_property(property_id)
        property.required = property_required?(property_id)
        property.many = property_many?(property_id)
        property.namespace = @default_prefix
        property
      end
    end

    def all_classes
      @ttl_graph.query([nil, RDF.type, RDF::RDFS.Class])
        .map(&:subject)
        .map(&:to_s)
    end

    def all_properties
      @ttl_graph.query([nil, RDF.type, RDF::RDFV.Property])
        .map(&:subject)
        .map(&:to_s)
    end

    def all_datatypes; end

    def subclasses_of_class(class_id)
      @ttl_graph.query([nil, RDF::RDFS.subClassOf, RDF::URI.new(class_id)]).map(&:subject).map(&:to_s)
    end

    def parents_of_class(class_id)
      @ttl_graph.query([RDF::URI.new(class_id), RDF::RDFS.subClassOf, nil]).map(&:object).map(&:to_s)
    end

    def comment_of_class(class_id)
      @ttl_graph.query([RDF::URI.new(class_id), RDF::RDFS.comment, nil]).map(&:object).map(&:to_s).first
    end

    def comment_of_property(property_id)
      @ttl_graph.query([RDF::URI.new(property_id), RDF::RDFS.comment, nil]).map(&:object).map(&:to_s).first
    end

    def range_of_property(property_id)
      @ttl_graph.query([
                         RDF::URI.new(property_id),
                         RDF::URI.new("#{@default_prefix}rangeIncludes"),
                         nil
                       ]).map(&:object).map(&:to_s)
    end

    def domain_of_property(property_id)
      @ttl_graph.query([
                         RDF::URI.new(property_id),
                         RDF::URI.new("#{@default_prefix}domainIncludes"),
                         nil
                       ]).map(&:object).map(&:to_s)
    end

    def property_required?(property_id)
      min_cardinalities = @ttl_graph.query([RDF::URI.new(property_id), RDF::OWL.minCardinality,
                                            nil]).map(&:object).map(&:to_i)
      min_cardinalities.empty? ? false : min_cardinalities.first.positive?
    end

    def property_many?(property_id)
      max_cardinalities = @ttl_graph.query([RDF::URI.new(property_id), RDF::OWL.maxCardinality,
                                            nil]).map(&:object)

      max_cardinalities.empty? ? true : max_cardinalities.map(&:to_i).first > 1
    end
  end
end