require 'chronicle/schema'
require 'chronicle/schema/rdf_parsing/ttl_graph_builder'

RSpec.shared_context 'with_sample_schema_graph', shared_context: :metadata do
  let(:sample_schema_graph) do
    sample_ttl_path = File.join(File.dirname(__FILE__), 'schema', 'sample.ttl')
    sample_ttl_str = File.read(sample_ttl_path)
    Chronicle::Schema::RDFParsing::TTLGraphBuilder.build_from_ttl(sample_ttl_str, default_namespace: 'https://schema.chronicle.app/')
  end

  let(:sample_model_module) do
    require 'chronicle/models/generation'

    Chronicle::Models::Generation.suppress_model_generation
    require 'chronicle/models'

    graph = sample_schema_graph

    Module.new do
      extend Chronicle::Models::Builder
      include Chronicle::Models::Generation

      generate_models(graph)
    end
  end
end
