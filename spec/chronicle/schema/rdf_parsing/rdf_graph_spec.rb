require 'spec_helper'
require 'chronicle/schema'
require 'chronicle/schema/rdf_parsing'

RSpec.describe Chronicle::Schema::RDFParsing::RDFGraph do
  let(:sample_ttl_str) do
    File.read(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'lib', 'chronicle', 'schema', 'data',
      'schemaorg.ttl'))
  end

  describe '#parse' do
    it 'should parse a sample ttl string and not raise errors' do
      expect { described_class.build_from_ttl(sample_ttl_str) }.to_not raise_error
    end

    it 'should be able to build a DAG of the rdf graph' do
      graph = described_class.build_from_ttl(sample_ttl_str)
    end
  end
end
