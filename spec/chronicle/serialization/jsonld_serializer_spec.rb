require 'spec_helper'
require 'chronicle/models/generation'
Chronicle::Models::Generation.suppress_model_generation
require 'chronicle/models'
require 'chronicle/serialization'

RSpec.describe Chronicle::Serialization::JSONLDSerializer do
  include_context 'with_sample_schema_graph'

  let(:schema_context) { { '@context': 'https://schema.chronicle.app/' } }

  it 'can build a JSONAPI object from a single model' do
    model = sample_model_module::Person.new(
      name: 'bar',
      description: 'identity'
    )

    expected = {
      '@type': 'Person',
      name: 'bar',
      description: 'identity'
    }.merge(schema_context)

    expect(described_class.serialize(model)).to eql(expected)
  end

  it 'can build a JSONAPI object from a model with a nested model' do
    model = sample_model_module::Action.new(
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
    }.merge(schema_context)

    expect(described_class.serialize(model)).to eql(expected)
  end

  it 'serializes dates properly' do
    model = sample_model_module::Event.new(
      start_date: Time.parse('2019-01-01')
    )

    expected = {
      '@type': 'Event',
      start_date: Time.parse('2019-01-01')
    }.merge(schema_context)

    expect(described_class.serialize(model)).to eql(expected)
  end
end
