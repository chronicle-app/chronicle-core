module Chronicle::Schema::RDFParsing
  # Represents a class in the RDF graph
  class RDFClass
    attr_reader :id
    attr_accessor :properties, :subclasses, :comment

    def initialize(id, comment = nil)
      @id = id
      @comment = comment
      @subclasses = []
      @properties = []
    end

    def pretty_print(pp)
      pp.text("RDFClass: #{id}")
      pp.nest(2) do
        pp.breakable
        pp.text("Subclasses: #{subclasses.map(&:id)}")
        pp.breakable
        pp.text("Comment: #{comment}")
        pp.breakable
        pp.text("Properties: #{properties.map(&:id)}")
      end
    end

    def ==(other)
      id == other.id
    end

    def add_subclass(subclass)
      @subclasses << subclass unless @subclasses.include?(subclass)
    end

    def add_property(property)
      @properties << property unless @properties.include?(property)
    end
  end
end
