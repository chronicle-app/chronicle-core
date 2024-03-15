module Chronicle::Schema::RDFParsing
  # A class that takes a parsed TTL file (DAG) and walks down through
  # the nodes, selecting some properties and selecting some subclasses
  # to include in a new output.
  # GraphTransformer.transform(schema_graph, root) do
  #   pick_subclass :Action do
  #     pick_subclass :CreateAction do
  #       pick_all_subclasses
  #     end
  #     pick_all_properties
  #   end

  #   pick_property :name
  #   pick_property :description
  # end
  #
  class GraphTransformer
    attr_reader :graph, :new_graph

    def initialize(graph)
      unless graph.is_a? Chronicle::Schema::SchemaGraph
        raise ArgumentError,
          'schema_graph must be a Chronicle::Schema::SchemaGraph'
      end

      @graph = graph
      @new_graph = Chronicle::Schema::SchemaGraph.new
      @current_parent = nil
    end

    def self.transform(graph, _root_id, &)
      transformer = new(graph)

      transformer.start_evaluating(&)

      transformer.new_graph.properties.each do |property|
        property.domain = property.domain.select do |class_id|
          transformer.new_graph.find_class_by_id(class_id)
        end
        # do the same thing for range but only after datatypes
      end

      transformer.new_graph.build_references!
      transformer.new_graph
    end

    def self.transform_from_file(graph, root_id, definition_file_path)
      dsl_commands = File.read(definition_file_path)
      transform(graph, root_id) do
        instance_eval(dsl_commands)
      end
    end

    def start_evaluating(&)
      instance_eval(&) if block_given?
    end

    private

    def version(version)
      @new_graph.version = version
    end

    def pick_subclass(subclass_identifier, &)
      subclass = @graph.find_class(subclass_identifier)
      raise ArgumentError, "Subclass not found: #{subclass_identifier}" unless subclass

      new_subclass = @new_graph.add_class(subclass_identifier)
      new_subclass.comment = subclass.comment

      @current_parent&.add_subclass_id(new_subclass.id)

      previous_parent = @current_parent
      @current_parent = new_subclass

      instance_eval(&) if block_given?

      @current_parent = previous_parent
    end

    def pick_all_subclasses(&)
      @graph.find_class_by_id(@current_parent.id).subclass_ids.each do |subclass_id|
        identifier = @graph.id_to_identifier(subclass_id)
        pick_subclass(identifier, &)
      end
    end

    def pick_property(property_identifier, many: false, required: false)
      property = @graph.find_property(property_identifier)
      raise ArgumentError, "Property not found: #{property_identifier}" unless property

      new_property = @new_graph.add_property(property_identifier)
      new_property.range = property.range
      new_property.comment = property.comment
      new_property.many = many
      new_property.required = required
      new_property.domain += [@current_parent.id]
    end

    def pick_all_properties
      @graph.find_class_by_id(@current_parent.id).properties.each do |property|
        identifier = @graph.id_to_identifier(property.id)
        pick_property(identifier)
      end
    end
  end
end
