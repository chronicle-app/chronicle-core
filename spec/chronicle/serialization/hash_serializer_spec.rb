require 'spec_helper'
require 'chronicle/serialization'

RSpec.describe Chronicle::Serialization::HashSerializer do
  let(:rock_group) do 
    {
      '@type': 'RockGroup',
      name: 'The Beatle',
      description: 'A rock band',
      hair_length: 5,
      video: [video_object]
    }
  end

  let(:album) do
    {
      '@type': 'MusicAlbum',
      name: 'White Album',
      description: 'asdfsda',
      by_artist: [rock_group, "asdfas"]
    }
  end
  # needs some fixing
  xit "can build a hash from a model" do
    expected = {
      type: "activities",
      attributes: { verb: "tested" },
      relationships: { agent: { data: { type: "person", attributes: { name: "bar", description: 'identity' }, relationships: {}, meta: { dedupe_on: [] } } } },
      meta: { dedupe_on: [] }
    }

    expect(Chronicle::Serialization::HashSerializer.serialize(record)).to eql(expected)
  end
end
