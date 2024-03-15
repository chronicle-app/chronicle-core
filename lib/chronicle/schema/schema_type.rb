module Chronicle::Schema
  # Represents a type in the RDF graph
  class SchemaType
    attr_reader :id, :namespace, :graph
    attr_accessor :properties,
      :subclass_ids,
      :comment,
      :subclasses,
      :superclasses

    def initialize(id, graph: nil, comment: nil, namespace: nil)
      @id = id
      @comment = comment
      @namespace = namespace
      @graph = graph
      @subclass_ids = []
      @properties = []
    end

    def inspect
      "#<SchemaType:#{id}>"
    end

    def pretty_print(pp)
      pp.text("SchemaType: #{id}")
      pp.nest(2) do
        pp.breakable
        pp.text("SubclassIds: #{subclass_ids.map(&:id)}")
        pp.breakable
        pp.text("Comment: #{comment}")
        pp.breakable
        pp.text("Properties: #{properties.map(&:id)}")
      end
    end

    def short_id
      id.gsub(@namespace, '')
    end

    def to_h
      {
        id:,
        comment:,
        subclass_ids:
      }
    end

    def ==(other)
      id == other.id
    end

    def add_subclass_id(subclass_id)
      @subclass_ids << subclass_id unless @subclass_ids.include?(subclass_id)
    end

    def ancestors
      @ancestors ||= begin
        ancestors = []

        queue = superclasses.dup
        until queue.empty?
          current = queue.shift
          ancestors << current
          queue.concat(current.superclasses)
        end
        ancestors
      end
    end

    def descendants
      @descendants ||= begin
        descendants = []

        queue = subclasses.dup
        until queue.empty?
          current = queue.shift
          descendants << current
          queue.concat(current.subclasses)
        end
        descendants
      end
    end

    def all_properties
      @all_properties ||= begin
        properties = @properties.dup
        ancestors.each do |ancestor|
          properties.concat(ancestor.properties)
        end
        properties
      end
    end

    def add_property(property)
      @properties << property unless @properties.include?(property)
    end
  end
end