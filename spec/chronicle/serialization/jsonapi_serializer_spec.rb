require 'spec_helper'

RSpec.describe Chronicle::Serialization::JSONAPISerializer do
  let(:record) do
    Chronicle::Schema::Action.new(
      id: 'afsad',
      verb: 'tested',
      actor: Chronicle::Schema::Person.new(
        description: 'identity',
        name: 'bar'
      ),
      object: Chronicle::Schema::MusicAlbum.new(
        name: 'foo'
      )
    )
  end

  # needs some fixing
  xit "can build a JSONAPI object from a model" do
    expected = {
      type: "activities",
      attributes: { verb: "tested" },
      relationships: { actor: { data: { type: "person", attributes: { name: "bar", description: 'identity' }, relationships: {}, meta: { dedupe_on: [] } } } },
      meta: { dedupe_on: [] }
    }

    expect(Chronicle::Serialization::JSONAPISerializer.serialize(record)).to eql(expected)
  end
end
