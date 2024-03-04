require 'tsort'
require 'rdf/turtle'

module Chronicle::Schema::RDFParsing
  # Represents a RDF graph as a DAG of classes and their properties, built
  # from a TTL string
  class RDFGraph
    include TSort

    attr_reader :ttl_graph, :classes, :properties, :datatypes

    def initialize(ttl_graph: nil)
      # FIXME: This should be a configuration option
      @default_prefix = 'https://schema.org/'
      @ttl_graph = ttl_graph
      @classes = []
      @properties = []
      @datatypes = []
    end

    def self.build_from_ttl(ttl_str)
      @ttl_graph = RDF::Graph.new.from_ttl(ttl_str)
      graph = new(ttl_graph: @ttl_graph)
      graph.build_from_ttl!
      graph
    end

    def pretty_print(pp)
      pp.text('RDFGraph')
      pp.nest(2) do
        pp.breakable
        pp.text("Num classes: #{classes.size}")
      end
    end

    def build_from_ttl!
      build_class_graph
      build_property_graph
      # build_datatype_graph
      add_properties_to_classes
    end

    def find_class_by_id(id)
      @classes.find { |c| c.id == id }
    end

    def find_class(identifier)
      @classes.find { |c| c.id == identifier_to_uri(identifier) }
    end

    def find_property(identifier)
      @properties.find { |p| p.id == identifier_to_uri(identifier) }
    end

    def add_class(identifier)
      find_class(identifier) || add_new_class(identifier)
    end

    def add_property(identifier)
      find_property(identifier) || add_new_property(identifier)
    end

    def id_to_identifier(id)
      id.gsub(@default_prefix, '')
    end

    private

    def add_new_class(identifier)
      new_class = RDFClass.new(identifier_to_uri(identifier))
      @classes << new_class unless @classes.include?(new_class)
      new_class
    end

    def add_new_property(identifier)
      new_property = RDFProperty.new(identifier_to_uri(identifier))
      @properties << new_property unless @properties.include?(new_property)
      new_property
    end

    def identifier_to_uri(identifier)
      "#{@default_prefix}#{identifier}"
    end

    def tsort_each_node(&block)
      @classes.each do |node|
        block.call(node)
      end
    end

    def tsort_each_child(node, &)
      puts "tsort_each_child called with node: #{node&.id}"
      node&.subclasses&.each(&)
    end

    def build_class_graph
      @classes = all_classes.map do |class_id|
        comment = comment_of_class(class_id)
        RDFClass.new(class_id, comment)
      end

      @classes.each do |rdf_class|
        rdf_class.subclasses = subclasses_of_class(rdf_class.id).map do |subclass_id|
          @classes.find { |c| c.id == subclass_id }
        end
      end
    end

    def build_property_graph
      @properties = all_properties.map do |property_id|
        property = RDFProperty.new(property_id)
        property.range = range_of_property(property_id)
        property.domain = domain_of_property(property_id)
        property.comment = comment_of_property(property_id)
        property
      end
    end

    def add_properties_to_classes
      @properties.each do |property|
        domain_classes = property.domain.map { |d| @classes.find { |c| c.id == d } }
        domain_classes.compact.each do |domain_class|
          domain_class.properties << property
        end
      end
    end

    def sort_by_number_of_subclasses
      @classes.sort_by { |c| c.subclasses.size }
    end

    def all_classes
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

    def subclasses_of_class(class_id)
      @ttl_graph.query([nil, RDF::RDFS.subClassOf, RDF::URI.new(class_id)]).map(&:subject).map(&:to_s)
    end

    def parents_of_class(class_id)
      @ttl_graph.query([RDF::URI.new(class_id), RDF::RDFS.subClassOf, nil]).map(&:object).map(&:to_s)
    end

    def comment_of_class(class_id)
      @ttl_graph.query([RDF::URI.new(class_id), RDF::RDFS.comment, nil]).map(&:object).map(&:to_s).first
    end

    def comment_of_property(property_id)
      @ttl_graph.query([RDF::URI.new(property_id), RDF::RDFS.comment, nil]).map(&:object).map(&:to_s).first
    end

    def range_of_property(property_id)
      @ttl_graph.query([
                         RDF::URI.new(property_id),
                         RDF::URI.new("#{@default_prefix}rangeIncludes"),
                         nil
                       ]).map(&:object).map(&:to_s)
    end

    def domain_of_property(property_id)
      @ttl_graph.query([
                         RDF::URI.new(property_id),
                         RDF::URI.new("#{@default_prefix}domainIncludes"),
                         nil
                       ]).map(&:object).map(&:to_s)
    end
  end
end
