module Chronicle::Schema
  # Represents a property in the RDF graph
  class SchemaProperty
    attr_reader :id
    attr_accessor :domain,
      :range,
      :comment,
      :many,
      :required,
      :namespace,
      :range_types, # FIXME
      :see_also

    def initialize(id)
      @id = id
      @domain = []
      @range = []
      @many = false
      @required = false

      yield self if block_given?
    end

    def pretty_print(pp)
      pp.text("SchemaProperty: #{id}")
      pp.nest(2) do
        pp.breakable
        pp.text("Range: #{range}")
        pp.breakable
        pp.text("Domain: #{domain}")
      end
    end

    def to_h
      output = {
        id:,
        domain:,
        range:,
        many: @many,
        required: @required
      }
      output[:comment] = @comment if @comment
      output[:see_also] = @see_also if @see_also
      output
    end

    def ==(other)
      id == other.id
    end

    def required?
      @required
    end

    def many?
      @many
    end

    def identifier
      @id.split('/').last&.to_sym
    end

    # FIXME
    def id_snakecase
      @id.split('/').last.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase.to_sym
    end

    # FIXME: refactor this and the next
    def range_identifiers
      range.map do |r|
        r.split('/').last&.to_sym
      end
    end

    def full_range_identifiers
      range_types.map(&:descendants).flatten.map { |x| x.id.split('/').last&.to_sym } + range_identifiers
    end
  end
end
