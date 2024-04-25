require 'open-uri'
require 'net/http'

module Chronicle
  module Schema
    module RDFParsing
      module Schemaorg
        @memoized_graphs = {}

        DEFAULT_NAMESPACE = 'https://schema.org/'.freeze

        def self.graph_for_version(version)
          @memoized_graphs[version] ||= build_graph(version)
        end

        def self.build_graph(version)
          ttl = ttl_for_version(version)
          Chronicle::Schema::RDFParsing::TTLGraphBuilder.build_from_ttl(ttl, default_namespace: DEFAULT_NAMESPACE)
        end

        def self.ttl_for_version(version)
          url = url_for_version(version)
          ttl_via_download(url)
        end

        def self.ttl_via_download(url)
          uri = URI(url)
          response = Net::HTTP.get_response(uri)
          raise "Error: #{response.message}" unless response.is_a?(Net::HTTPSuccess)

          response.body
        end

        def self.seed_graph_from_file(version, file_path)
          ttl = File.read(file_path)
          graph = Chronicle::Schema::RDFParsing::TTLGraphBuilder.build_from_ttl(ttl,
            default_namespace: DEFAULT_NAMESPACE)
          @memoized_graphs[version] = graph
        end

        def self.url_for_version(version)
          "https://schema.org/version/#{version}/schemaorg-current-https.ttl"
        end
      end
    end
  end
end
