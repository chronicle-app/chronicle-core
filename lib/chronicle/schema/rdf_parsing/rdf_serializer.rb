require 'rdf/turtle'

module Chronicle::Schema::RDFParsing
  PREFIXES = {
    '': 'https://schema.org/',
    owl: 'http://www.w3.org/2002/07/owl#',
    dc: 'http://purl.org/dc/terms/',
    rdf: 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
    rdfs: 'http://www.w3.org/2000/01/rdf-schema#',
    xml: 'http://www.w3.org/XML/1998/namespace',
    xsd: 'http://www.w3.org/2001/XMLSchema#'
  }.freeze

  # Take a graph and serialize it as a ttl string
  class RDFSerializer
    attr_reader :graph

    def initialize(graph)
      raise ArgumentError, 'graph must be a RDFGraph' unless graph.is_a?(RDFGraph)

      @graph = graph
    end

    def self.serialize(graph)
      new(graph).serialize
    end

    def serialize
      rdf_graph = RDF::Graph.new
      graph.classes.each do |klass|
        serialize_class(klass).each do |triple|
          # binding.pry
          rdf_graph << triple
        end
      end

      graph.properties.each do |property|
        serialize_property(property).each do |triple|
          rdf_graph << triple
        end
      end

      rdf_graph.dump(:ttl, prefixes: PREFIXES)
    end

    private

    def serialize_class(klass)
      statements = []
      statements << RDF::Statement(RDF::URI.new(klass.id), RDF.type, RDF::RDFS.Class)
      statements << RDF::Statement(RDF::URI.new(klass.id), RDF::RDFS.comment, klass.comment) if klass.comment

      @graph.classes.filter { |c| c.subclasses.include?(klass) }.each do |parent|
        statements << RDF::Statement(RDF::URI.new(klass.id), RDF::RDFS.subClassOf, RDF::URI.new(parent.id))
      end

      statements
    end

    def serialize_property(property)
      statements = []

      statements << RDF::Statement(RDF::URI.new(property.id), RDF.type, RDF::RDFV.Property)
      property.range.each do |range|
        statements << RDF::Statement(RDF::URI.new(property.id), RDF::URI.new('https://schema.org/rangeIncludes'),
          RDF::URI.new(range))
      end

      @graph.classes.filter { |c| c.properties.include?(property) }.each do |domain|
        statements << RDF::Statement(RDF::URI.new(property.id), RDF::URI.new('https://schema.org/domainIncludes'),
          RDF::URI.new(domain.id))
      end

      statements << RDF::Statement(RDF::URI.new(property.id), RDF::RDFS.comment, property.comment) if property.comment

      statements
    end
  end
end
