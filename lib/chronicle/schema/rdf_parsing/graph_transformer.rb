module Chronicle
  module Schema
    module RDFParsing
      # A class that inteprets a DSL to transform a base schema graph into
      # a new one by walking through the types and properties of the base
      # and selecting which ones to include in the new graph.
      class GraphTransformer
        attr_reader :graph, :base_graph, :new_graph

        def initialize
          @base_graph = nil
          @new_graph = Chronicle::Schema::SchemaGraph.new(default_namespace: 'https://schema.chronicle.app/')
          @current_parent = nil
        end

        def self.transform(&)
          transformer = new
          transformer.start_evaluating(&)

          # TODO: figure out if we need to this still
          transformer.new_graph.properties.each do |property|
            property.domain = property.domain.select do |type_id|
              transformer.new_graph.find_type_by_id(type_id)
            end
          end

          transformer.new_graph.build_references!
          transformer.new_graph
        end

        def self.transform_from_file(definition_file_path)
          dsl_commands = File.read(definition_file_path)
          transform_from_string(dsl_commands)
        end

        def self.transform_from_string(dsl_definition)
          transform do
            instance_eval(dsl_definition)
          end
        end

        def start_evaluating(&)
          instance_eval(&) if block_given?
        end

        private

        def version(version)
          @new_graph.version = version
        end

        def set_base_graph(name, version)
          case name
          when 'schema.org'
            @base_graph = Chronicle::Schema::RDFParsing::Schemaorg.graph_for_version(version)
          else
            raise ArgumentError, "Unknown base graph: #{name}"
          end
        end

        def pick_type(subtype_identifier, &)
          id = @base_graph.identifier_to_uri(subtype_identifier)
          type = @base_graph.find_type_by_id(id)
          raise ArgumentError, "Subtype not found: #{subtype_identifier}" unless type

          new_subtype = @new_graph.add_type(subtype_identifier)
          new_subtype.comment = type.comment
          new_subtype.see_also = type.id

          @current_parent&.add_subtype_id(new_subtype.id)

          previous_parent = @current_parent
          @current_parent = new_subtype

          instance_eval(&) if block_given?

          @current_parent = previous_parent
        end

        # add a new type that's child of the parent
        def add_type(identifier, comment: nil, &)
          new_type = @new_graph.add_type(identifier)
          new_type.comment = comment

          @current_parent&.add_subtype_id(new_type.id)

          previous_parent = @current_parent
          @current_parent = new_type

          instance_eval(&) if block_given?

          @current_parent = previous_parent
        end

        def pick_all_subtypes(&)
          @base_graph.find_type(@current_parent.short_id.to_sym).subtype_ids.each do |subtype_id|
            identifier = @base_graph.id_to_identifier(subtype_id)
            pick_type(identifier, &)
          end
        end

        def apply_property(property_identifier, many: false, required: false)
          property = @base_graph.find_property(property_identifier)
          raise ArgumentError, "Property not found: #{property_identifier}" unless property

          new_property = @new_graph.add_property(property_identifier)
          new_property.range = property.range.map do |p|
            base_range_type = @base_graph.find_type_by_id(p)
            @new_graph.identifier_to_uri(base_range_type.identifier)
          end
          new_property.comment = property.comment
          new_property.many = many
          new_property.required = required
          new_property.domain += [@current_parent.id]
          new_property.see_also = property.id
        end

        def add_property(property_identifier, many: false, required: false, comment: nil)
          new_property = @new_graph.add_property(property_identifier)
          new_property.domain += [@current_parent.id]
          # TODO: expand this to handle multiple ranges
          new_property.range = [@new_graph.identifier_to_uri(:Text)]
          new_property.comment = comment
          new_property.many = many
          new_property.required = required
        end

        def pick_all_properties
          @base_graph.find_type_by_id(@current_parent.id).properties.each do |property|
            identifier = @base_graph.id_to_identifier(property.id)
            apply_property(identifier)
          end
        end
      end
    end
  end
end
