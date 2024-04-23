require 'spec_helper'

# require 'chronicle/schema/generators/rdf_parser'
require 'chronicle/schema'
require 'chronicle/schema/validation'
require 'chronicle/schema/rdf_parsing/ttl_graph_builder'

RSpec.describe Chronicle::Schema::Validation::Validator do
  include_context 'with_sample_schema_graph'

  before(:each) do
    Chronicle::Schema::Validation::Generation.generate_contracts(sample_schema_graph)
  end

  let(:bogus) do
    {
      '@type': 'Bogus',
      name: 'asdfas'
    }
  end

  let(:invalid) do
    {
      '@type': 'MusicGroup',
      name: 5
    }
  end

  let(:music_group) do
    {
      '@type': 'MusicGroup',
      name: 'The Beatle',
      description: 'A rock band',
      alternate_name: 'x'
    }
  end

  let(:album) do
    {
      '@type': 'MusicAlbum',
      # name: 'White Album',
      description: 'asdfsda',
      # FIXME: handle text fallback for edges
      # by_artist: [music_group, 'asdfas']
      by_artist: [music_group]
    }
  end

  let(:place) do
    {
      '@type': 'Place',
      name: 'Toronto',
      description: 'A city'
    }
  end

  context 'for simple objects' do
    subject { described_class.call(music_group) }

    it 'can validate a simple object' do
      expect(subject).to be_considered_valid
    end

    it 'uses snake case for properties' do
      expect(subject.to_h[:alternate_name]).to eq('x')
    end
  end

  context 'for generally invalid input' do
    it 'raises an error when class unknown' do
      expect { described_class.call(bogus) }.to raise_error(Chronicle::Schema::ValidationError, /not a valid type/)
    end

    describe 'invalid properties' do
      it 'does not allow unknown properties' do
        obj = {
          '@type': 'MusicGroup',
          foo: 'bar'
        }

        subject = described_class.call(obj)

        expect(subject).to be_considered_invalid([:foo])
      end

      it 'does not allow deeply-nested unknown properties' do
        obj = {
          '@type': 'MusicAlbum',
          by_artist: [music_group.merge(foo: 'bar')]
        }

        subject = described_class.call(obj)
        expect(subject.success?).to be_falsey
      end
    end
  end

  context 'for object with edges' do
    subject { described_class.call(album) }

    it 'can validate an object with edges' do
      expect(subject).to be_considered_valid
    end

    it 'will not validate an object with wrong literal type' do
      bad_album = album.merge(by_artist: [5])

      expect(described_class.call(bad_album)).to be_considered_invalid([:by_artist])
    end

    it 'will not validate an object with non-valid schema type' do
      bad_album = album.merge(by_artist: [bogus])

      expect(described_class.call(bad_album)).to be_considered_invalid([:by_artist])
    end

    it 'will not validate an object with non-valid schema' do
      bad_album = album.merge(by_artist: [invalid])

      expect(described_class.call(bad_album)).to be_considered_invalid([:by_artist])
    end

    it 'will not validate an object with wrong cardinality' do
      bad_album = album.merge(by_artist: music_group)
      expect(described_class.call(bad_album)).to be_considered_invalid([:by_artist])
    end

    it 'will validate a deeply nested edges' do
      deep_album = album.merge(by_artist: [music_group.merge(location: [place])])
      expect(described_class.call(deep_album)).to be_considered_valid
    end

    describe 'value coercions' do
      # FIXME: not sure why this isn't working
      it 'will coerce an object' do
        obj = {
          '@type': 'Event',
          end_date: '2023-10-27T11:54:08.000-04:00'
        }
        result = described_class.call(obj)

        expect { result }.to_not raise_error
        expect(result).to be_considered_valid
        expect(result.to_h[:end_date].class).to eq(Time)
      end

      it 'will coerce a deeply-nested object' do
        obj = {
          '@type': 'CreativeWork',
          name: 'foo',
          about: [{
            '@type': 'Event',
            start_date: '2024-03-14'
          }]
        }
        result = described_class.call(obj)

        expect { result }.to_not raise_error
        expect(result).to be_considered_valid
        expect(result.to_h[:about][0][:start_date].class).to eq(Time)
      end
    end

    # TODO: needs work on edge_validator
    it 'will not validate an object with non-acceptable edge type' do
      bad_album = album.merge(by_artist: [album])

      expect(described_class.call(bad_album)).to be_considered_invalid([:by_artist])
    end

    it 'will not validate an object with non-acceptable deeply-nested edge type' do
      bad_album = album.merge(by_artist: [music_group.merge(album: [album.merge(by_artist: [album])])])
      subject = described_class.call(bad_album)
      expect(subject).to be_considered_invalid([:by_artist])
    end
  end

  context 'real life data' do
    it 'can validate' do
      data = {
        '@type' => 'Action',
        'agent' => {
          '@type' => 'Person',
          # 'provider' => 'lastfm',
          # 'provider_slug' => 'hyfen',
          'name' => 'Andrew Louis',
          'url' => 'http://www.last.fm/user/hyfen'
        },
        'object' =>
        { '@type' => 'MusicRecording',
          # 'provider' => 'lastfm',
          # 'provider_id' => '0bbc57a5-ab84-3164-8ec1-a23480621512',
          'by_artist' => [
            { '@type' => 'MusicGroup',
              # 'provider' => 'lastfm',
              'name' => 'John Talabot',
              'url' => 'https://www.last.fm/music/John+Talabot' }
          ],
          'in_album' => [
            { '@type' => 'MusicAlbum',
              # 'provider' => 'lastfm',
              'name' => 'Fin' }
          ],
          'name' => 'Depak Ine',
          'url' => 'https://www.last.fm/music/John+Talabot/_/Depak+Ine' },
        'end_time' => '2023-10-27T11:54:08.000-04:00'
      }

      result = described_class.call(data)
      expect(result).to be_considered_valid
    end
  end
end
