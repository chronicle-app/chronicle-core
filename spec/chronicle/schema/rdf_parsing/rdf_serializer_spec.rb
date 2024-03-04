require 'spec_helper'
require 'chronicle/schema'
require 'chronicle/schema/rdf_parsing'

RSpec.describe Chronicle::Schema::RDFParsing::RDFSerializer do
  let(:sample_ttl_str) do
    File.read(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'lib', 'chronicle', 'schema', 'data',
      'schemaorg.ttl'))
  end

  let(:sample_graph) do
    Chronicle::Schema::RDFParsing::RDFGraph.build_from_ttl(sample_ttl_str)
  end

  let(:transformed) do
    Chronicle::Schema::RDFParsing::GraphTransformer.transform(sample_graph, :Thing) do
      pick_subclass :Action do
        pick_property :endTime
        pick_subclass :CreateAction
      end

      pick_subclass :Person
      pick_subclass :Organization do
        pick_all_subclasses
      end

      pick_property :name
      pick_property :description
    end
  end

  describe '#serialize' do
    it 'should create a valid rdf' do
      serialized = described_class.serialize(transformed)
      puts serialized
    end
  end
end