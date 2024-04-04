require 'spec_helper'
require 'chronicle/serialization'

RSpec.describe Chronicle::Serialization::JSONAPISerializer do
  include_context 'with_sample_schema_graph'

  let(:event_model) do
    sample_model_module::Event.new(
      end_date: Time.parse('2019-01-01')
    )
  end

  let(:music_group_model) do
    sample_model_module::MusicGroup.new(
      name: 'The Beatles'
    )
  end

  let(:album_model) do
    sample_model_module::MusicAlbum.new(
      name: 'White Album',
      by_artist: [music_group_model, music_group_model]
    )
  end

  it 'can build a JSONAPI object from a single model' do
    expect(described_class.serialize(event_model)).to eql({
      data: {
        type: 'Event',
        meta: {},
        relationships: {},
        attributes: {
          end_date: Time.parse('2019-01-01')
        }
      }
    })
  end

  it 'can build a JSONAPI object from a model with a relationship' do
    expect(described_class.serialize(album_model)).to eql({
      data: {
        type: 'MusicAlbum',
        meta: {},
        relationships: {
          by_artist: {
            data: [
              {
                type: 'MusicGroup',
                attributes: { name: 'The Beatles' }, relationships: {}, meta: {}
              },
              {
                type: 'MusicGroup',
                attributes: { name: 'The Beatles' }, relationships: {}, meta: {}
              }
            ]
          }
        },
        attributes: {
          name: 'White Album'
        }
      }
    })
  end
end
