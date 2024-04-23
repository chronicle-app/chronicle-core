require 'spec_helper'
require 'chronicle/serialization'

RSpec.describe Chronicle::Serialization::HashSerializer do
  include_context 'with_sample_schema_graph'

  it 'can build a hash from a single model' do
    properties = {
      name: 'bar',
      description: 'identity'
    }
    model = sample_model_module::Person.new(properties)

    expect(described_class.serialize(model)).to eql(properties.merge(type: :Person))
  end

  it 'can build a hash from a model with a nested model' do
    model = sample_model_module::Action.new(
      id: '123',
      agent: sample_model_module::Person.new(
        name: 'bar',
        description: 'identity'
      )
    )

    expect(described_class.serialize(model)).to eql({
      type: :Action,
      id: '123',
      agent: {
        type: :Person,
        name: 'bar',
        description: 'identity'
      }
    })
  end
end
