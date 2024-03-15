module Chronicle::Schema
  # Represents a property in the RDF graph
  class SchemaProperty
    attr_reader :id
    attr_accessor :domain, :range, :comment, :many, :required, :namespace

    def initialize(id)
      @id = id
      @domain = []
      @range = []
      @many = false
      @required = false
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
      {
        id:,
        comment:,
        domain:,
        range:,
        many: @many,
        required: @required
      }
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

    # FIXME
    def id_snakecase
      @id.split('/').last.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase.to_sym
    end

    # FIXME
    def range_identifiers
      range.map do |r|
        r.split('/').last&.to_sym
      end
    end
  end
end
