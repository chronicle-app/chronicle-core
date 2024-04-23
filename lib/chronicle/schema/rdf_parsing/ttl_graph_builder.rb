require 'tsort'
require 'rdf/turtle'
require_relative '../schema_graph'
require_relative '../schema_type'
require_relative '../schema_property'

module Chronicle
  module Schema
    module RDFParsing
      class TTLGraphBuilder
        attr_reader :ttl_str, :ttl_graph, :graph

        def initialize(ttl_str, default_namespace: 'https://schema.org/')
          @ttl_str = ttl_str
          @default_namespace = default_namespace
          @graph = Chronicle::Schema::SchemaGraph.new(default_namespace:)
        end

        def build
          reader = RDF::Reader.for(:ttl).new(@ttl_str)
          @ttl_graph = RDF::Graph.new << reader

          @graph.version = get_version
          @graph.types = build_type_graph
          @graph.properties = build_property_graph
          # build_datatype_graph
          @graph.build_references!
          @graph
        end

        def self.build_from_file(file_path, default_namespace:)
          new(File.read(file_path), default_namespace:).build
        end

        def self.build_from_ttl(ttl_str, default_namespace:)
          new(ttl_str, default_namespace:).build
        end

        private

        # TODO: make this use proper schema
        def get_version
          @ttl_graph.query([nil, RDF::OWL.versionInfo, nil]).map(&:object).map(&:to_s).first
        end

        def build_type_graph
          types = all_types.map do |type_id|
            comment = comment_of_class(type_id)
            Chronicle::Schema::SchemaType.new(type_id) do |t|
              t.comment = comment
              t.namespace = @default_namespace
              t.see_also = see_also(type_id)
            end
          end

          types.each do |schema_type|
            schema_type.subtype_ids = subtypes_of_class(schema_type.id)
          end

          types
        end

        def build_property_graph
          all_properties.map do |property_id|
            Chronicle::Schema::SchemaProperty.new(property_id) do |p|
              p.range = range_of_property(property_id)
              p.domain = domain_of_property(property_id)
              p.comment = comment_of_property(property_id)
              p.required = property_required?(property_id)
              p.many = property_many?(property_id)
              p.namespace = @default_namespace
              p.see_also = see_also(property_id)
            end
          end
        end

        def all_types
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

        def subtypes_of_class(type_id)
          @ttl_graph.query([nil, RDF::RDFS.subClassOf, RDF::URI.new(type_id)]).map(&:subject).map(&:to_s)
        end

        def parents_of_class(type_id)
          @ttl_graph.query([RDF::URI.new(type_id), RDF::RDFS.subClassOf, nil]).map(&:object).map(&:to_s)
        end

        def comment_of_class(type_id)
          @ttl_graph.query([RDF::URI.new(type_id), RDF::RDFS.comment, nil]).map(&:object).map(&:to_s).first
        end

        def comment_of_property(property_id)
          @ttl_graph.query([RDF::URI.new(property_id), RDF::RDFS.comment, nil]).map(&:object).map(&:to_s).first
        end

        def range_of_property(property_id)
          @ttl_graph.query([
                             RDF::URI.new(property_id),
                             RDF::URI.new("#{@default_namespace}rangeIncludes"),
                             nil
                           ]).map(&:object).map(&:to_s)
        end

        def domain_of_property(property_id)
          @ttl_graph.query([
                             RDF::URI.new(property_id),
                             RDF::URI.new("#{@default_namespace}domainIncludes"),
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

        def see_also(id)
          @ttl_graph.query([RDF::URI.new(id), RDF::RDFS.seeAlso, nil]).map(&:object).map(&:to_s).first
        end
      end
    end
  end
end
