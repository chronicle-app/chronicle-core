require 'spec_helper'
require 'chronicle/models/generation'
Chronicle::Models::Generation.suppress_model_generation
require 'chronicle/models'
require 'chronicle/serialization'

RSpec.describe Chronicle::Serialization::JSONLDSerializer do
  include_context 'with_sample_schema_graph'

  it 'can build a JSONAPI object from a single model' do
    record = sample_model_module::Person.new(
      name: 'bar',
      description: 'identity'
    )

    expected = {
      '@type': 'Person',
      name: 'bar',
      description: 'identity'
    }

    expect(described_class.serialize(record)).to eql(expected)
  end

  it 'can build a JSONAPI object from a model with a nested model' do
    record = sample_model_module::Action.new(
      agent: sample_model_module::Person.new(
        name: 'bar',
        description: 'identity'
      )
    )

    expected = {
      '@type': 'Action',
      agent: {
        '@type': 'Person',
        name: 'bar',
        description: 'identity'
      }
    }

    expect(described_class.serialize(record)).to eql(expected)
  end

  it 'serializes dates properly' do
    record = sample_model_module::Event.new(
      start_date: Time.parse('2019-01-01')
    )

    expected = {
      '@type': 'Event',
      start_date: Time.parse('2019-01-01')
    }

    expect(described_class.serialize(record)).to eql(expected)
  end
end
