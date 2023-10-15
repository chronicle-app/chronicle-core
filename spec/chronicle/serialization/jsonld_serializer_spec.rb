require 'spec_helper'

RSpec.describe Chronicle::Serialization::JSONLDSerializer do
  let(:record) do
    Chronicle::Schema::Activity.new(
      id: 'afsad',
      verb: 'tested',
      actor: Chronicle::Schema::Person.new(
        description: 'identity',
        name: 'bar'
      )
    )
  end

  it "can build a JSONAPI object from a model" do
    expected = {
      '@type': "Activity",
      id: "afsad",
      verb: "tested",
      actor: {
        '@type': 'Person',
        name: 'bar',
        description: 'identity'
      }
    }

    expect(described_class.serialize(record)).to eql(expected)
  end
end
