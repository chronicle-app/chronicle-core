require 'open-uri'
require 'net/http'

module Chronicle::Schema::RDFParsing
  module Schemaorg
    def self.ttl_via_download
      require 'open-uri'
      require 'fileutils'

      # TODO: be able to specify versions
      # Versions described here (but not often tagged on git):
      # https://raw.githubusercontent.com/schemaorg/schemaorg/main/versions.json

      schema_url_latest = 'https://raw.githubusercontent.com/schemaorg/schemaorg/main/data/schema.ttl'

      url = URI(schema_url_latest)
      file = url.open
      file.read
    rescue OpenURI::HTTPError => e
      raise "Error: #{e.message}"
    end

    def self.build_graph(ttl = nil)
      ttl ||= ttl_via_download
      Chronicle::Schema::RDFParsing::TTLGraphBuilder.build_from_ttl(ttl)
    end
  end
end
