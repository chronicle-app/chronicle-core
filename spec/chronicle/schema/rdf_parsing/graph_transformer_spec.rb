require 'chronicle/schema'
require 'chronicle/schema/rdf_parsing'

RSpec.describe Chronicle::Schema::RDFParsing::GraphTransformer do
  before(:all) do
    ttl_file = File.join(File.dirname(__FILE__), '..', '..', '..', 'support', 'schema', 'schemaorg.ttl')
    Chronicle::Schema::RDFParsing::Schemaorg.seed_graph_from_file('latest', ttl_file)
  end

  # create a sample dsl definition of a transformer
  let(:dsl_definition) do
    <<~DSL
      version '2'
      set_base_graph 'schema.org', 'latest'

      pick_subclass :Thing do
        pick_property :name
        pick_subclass :Person do
        end
      end
    DSL
  end

  describe '.transform' do
    subject { described_class.transform_from_string(dsl_definition) }

    it 'returns a graph' do
      expect(subject).to be_a(Chronicle::Schema::SchemaGraph)
    end

    it 'has a version' do
      expect(subject.version).to eq('2')
    end

    it 'has the right types' do
      expect(subject.find_class(:Thing)).to be_a(Chronicle::Schema::SchemaType)
      expect(subject.find_class(:Thing).descendants).to include(subject.find_class(:Person))
    end

    it 'has the right properties' do
      expect(subject.find_class(:Person).all_properties).to include(subject.find_property(:name))
    end
  end
end
