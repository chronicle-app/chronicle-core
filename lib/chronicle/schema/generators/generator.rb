require_relative 'rdf_parser'
module Chronicle::Schema::Generators
  class Generator
    def initialize(parsed_schema, namespace: 'Chronicle::Schema')
      @parsed_schema = parsed_schema
      @namespace = namespace
    end

    def self.generate_from_ttl_path(path)
      parsed = Chronicle::Schema::Generators::RDFParser.parse_ttl_file(path)
      self.new(parsed).generate
    end

    private

    def with_indent(str, level)
      str.split("\n").map { |line| "#{'  ' * level}#{line.strip}" }.join("\n")
    end
  end
end
