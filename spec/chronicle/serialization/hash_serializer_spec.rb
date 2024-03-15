require 'spec_helper'
require 'chronicle/serialization'

RSpec.describe Chronicle::Serialization::HashSerializer do
  include_context 'with_sample_schema_graph'

  it 'can build a JSONAPI object from a single model' do
    properties = {
      name: 'bar',
      description: 'identity'
    }
    record = sample_model_module::Person.new(properties)

    expect(described_class.serialize(record)).to eql(properties)
  end

  it 'can build a JSONAPI object from a model with a nested model' do
    record = sample_model_module::Action.new(
      agent: sample_model_module::Person.new(
        name: 'bar',
        description: 'identity'
      )
    )

    expect(described_class.serialize(record).compact).to eql({
      agent: {
        name: 'bar',
        description: 'identity'
      }
    })
  end
end
