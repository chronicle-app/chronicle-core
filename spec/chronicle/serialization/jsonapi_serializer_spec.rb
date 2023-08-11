require 'spec_helper'

RSpec.describe Chronicle::Serialization::JSONAPISerializer do
  let(:record) do
    Chronicle::Schema::Activity.new(
      provider: 'foo',
      verb: 'tested',
      actor: Chronicle::Schema::Entity.new(
        represents: 'identity',
        provider: 'bar'
      )
    )
  end

  it "can build a JSONAPI object from a model" do
    expected = {
      type: "activities",
      attributes: { provider: "foo", verb: "tested" },
      relationships: { actor: { data: { type: "entities", attributes: { provider: "bar", represents: "identity" }, relationships: {}, meta: { dedupe_on: [] } } } },
      meta: { dedupe_on: [] }
    }

    expect(Chronicle::Serialization::JSONAPISerializer.serialize(record)).to eql(expected)
  end
end
