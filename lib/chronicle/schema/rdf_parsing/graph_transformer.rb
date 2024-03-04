module Chronicle::Schema::RDFParsing
  # A class that takes a parsed TTL file (DAG) and walks down through
  # the nodes, selecting some properties and selecting some subclasses
  # to include in a new output.
  # GraphTransformer.transform(rdf_graph, root) do
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
      unless graph.is_a? Chronicle::Schema::RDFParsing::RDFGraph
        raise ArgumentError,
          'rdf_graph must be a Chronicle::Schema::RDFParsing::RDFGraph'
      end

      @graph = graph
      @new_graph = Chronicle::Schema::RDFParsing::RDFGraph.new
      @current_parent = nil
    end

    def self.transform(graph, root_id, &)
      transformer = new(graph)

      transformer.pick_subclass(root_id, &)

      transformer.new_graph
    end

    def pick_subclass(subclass_identifier, &)
      subclass = @graph.find_class(subclass_identifier)
      raise ArgumentError, "Subclass not found: #{subclass_identifier}" unless subclass

      new_subclass = @new_graph.add_class(subclass_identifier)
      new_subclass.comment = subclass.comment

      @current_parent&.add_subclass(new_subclass)

      previous_parent = @current_parent
      @current_parent = new_subclass

      instance_eval(&) if block_given?

      @current_parent = previous_parent
    end

    def pick_all_subclasses(&)
      @graph.find_class_by_id(@current_parent.id).subclasses.each do |subclass|
        identifier = @graph.id_to_identifier(subclass.id)
        pick_subclass(identifier, &)
      end
    end

    def pick_property(property_identifier)
      property = @graph.find_property(property_identifier)
      raise ArgumentError, "Property not found: #{property_identifier}" unless property

      new_property = @new_graph.add_property(property_identifier)
      new_property.range = property.range
      new_property.comment = property.comment
      @current_parent&.add_property(new_property)
    end

    def pick_all_properties
      @graph.find_class_by_id(@current_parent.id).properties.each do |property|
        identifier = @graph.id_to_identifier(property.id)
        pick_property(identifier)
      end
    end
  end
end
