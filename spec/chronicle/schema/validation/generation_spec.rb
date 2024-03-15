require 'spec_helper'
# require 'chronicle/schema/validation'
require 'chronicle/schema'
require 'chronicle/schema/rdf_parsing/ttl_graph_builder'

RSpec.describe Chronicle::Schema::Validation::Generation do
  include_context 'with_sample_schema_graph'

  it 'can build a schema' do
    Chronicle::Schema::Validation::Generation.generate_contracts(sample_schema_graph)

    contract = Chronicle::Schema::Validation.get_contract(:Person)
    expect(contract).to_not be_nil
    expect(contract.new).to respond_to(:call)
    expect(contract.new.call({}).success?).to be_falsey
  end
end
