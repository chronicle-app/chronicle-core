module Chronicle::Schema
  # Represents a type in the RDF graph
  #
  # TODO: rename `class` to `type` to match new class name
  class SchemaType
    attr_reader :id
    attr_accessor :properties,
      :subtype_ids,
      :comment,
      :namespace,
      :subtypes,
      :supertypes,
      :see_also

    def initialize(id)
      @id = id
      @subtype_ids = []
      @properties = []

      yield self if block_given?
    end

    def inspect
      "#<SchemaType:#{id}>"
    end

    def pretty_print(pp)
      pp.text("SchemaType: #{id}")
      pp.nest(2) do
        pp.breakable
        pp.text("subtypeIds: #{subtype_ids.map(&:id)}")
        pp.breakable
        pp.text("Comment: #{comment}")
        pp.breakable
        pp.text("Properties: #{properties.map(&:id)}")
      end
    end

    def short_id
      id.gsub(@namespace, '')
    end

    # FIXME
    def identifier
      short_id.to_sym
    end

    def to_h
      output = {
        id:,
        subtype_ids:
      }
      output[:see_also] = @see_also if @see_also
      output[:comment] = @comment if @comment
      output
    end

    def ==(other)
      id == other.id
    end

    def add_subtype_id(subtype_id)
      @subtype_ids << subtype_id unless @subtype_ids.include?(subtype_id)
    end

    def ancestors
      @ancestors ||= begin
        ancestors = []

        queue = supertypes.dup
        until queue.empty?
          current = queue.shift
          ancestors << current
          queue.concat(current.supertypes)
        end
        ancestors
      end
    end

    def descendants
      @descendants ||= begin
        descendants = []

        queue = subtypes.dup
        until queue.empty?
          current = queue.shift
          descendants << current
          queue.concat(current.subtypes)
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
