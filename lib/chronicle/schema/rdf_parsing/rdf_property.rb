module Chronicle::Schema::RDFParsing
  # Represents a property in the RDF graph
  class RDFProperty
    attr_reader :id
    attr_accessor :domain, :range, :comment

    def initialize(id)
      @id = id
      @domain = []
      @range = []
    end

    def pretty_print(pp)
      pp.text("RDFProperty: #{id}")
      pp.nest(2) do
        pp.breakable
        pp.text("Range: #{range}")
        pp.breakable
        pp.text("Domain: #{domain}")
      end
    end

    def ==(other)
      id == other.id
    end
  end
end
