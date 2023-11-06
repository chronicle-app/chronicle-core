require 'spec_helper'

require 'chronicle/schema/generators/rdf_parser'

# rubocop:disable Lint/ConstantDefinitionInBlock

RSpec.describe Chronicle::Schema::Validation::Validator do
  before(:each) do
    sample_ttl_path = File.join(File.dirname(__FILE__), '..', '..', '..', 'support', 'schema', 'sample.ttl')
    sample_ttl_str = File.read(sample_ttl_path)
    schema_class_data = Chronicle::Schema::Generators::RDFParser.new(sample_ttl_str).parse.classes

    Chronicle::Schema::Validation::Generation.generate_contracts(schema_class_data)
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

  let(:video_object) do
    {
      '@type': 'VideoObject',
      name: 'Video'
    }
  end

  let(:music_group) do
    {
      '@type': 'MusicGroup',
      name: 'asdas'
    }
  end

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

  context 'for simple objects' do
    subject { described_class.call(rock_group) }

    it 'can validate a simple object' do
      expect(subject).to be_considered_valid
    end

    it 'uses snake case for properties' do
      expect(subject.to_h[:hair_length]).to eq(5)
    end
  end

  context 'for generally invalid input' do
    it 'raises an error when class unknown' do
      expect { described_class.call(bogus) }.to raise_error(Chronicle::Schema::ValidationError, /not a valid type/)
    end

    it 'can does not allow unknown keys' do
      obj = {
        '@type': 'MusicGroup',
        foo: 'bar'
      }

      subject = described_class.call(obj)

      expect(subject).to be_considered_valid
      expect(subject.to_h).to_not include(:foo)
    end
  end

  context 'for object with edges' do
    subject { described_class.call(album) }

    it 'can validate an object with edges' do
      expect(subject).to be_considered_valid
    end

    it 'will not validate an object with wrong literal type' do
      bad_album = album.merge(by_artist: [5])

      expect(described_class.call(bad_album)).to be_considered_invalid( [:by_artist])
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
      bad_album = album.merge(by_artist: rock_group)
      expect(described_class.call(bad_album)).to be_considered_invalid([:by_artist])
    end

    it 'will validate a deeply nested edges' do
      deep_album = album.merge(by_artist: [rock_group.merge(video: [video_object])])
      expect(described_class.call(deep_album)).to be_considered_valid
    end

    describe 'value coercions' do
      # FIXME: not sure why this isn't working
      it 'will coerce an object' do
        obj = rock_group.merge(formed_on: '2023-10-01')
        result = described_class.call(obj)

        expect { result }.to_not raise_error
        expect(result).to be_considered_valid
        expect(result.to_h[:formed_on].class).to eq(Time)
      end

      it 'will coerce a deeply-nested object' do
        obj = album.merge({
          test: [{
            '@type': 'Text',
            value: 'asdfdas',
            by_artist: [rock_group]
          }],
          description: {
            '@type': 'Text',
            value: {
              '@type': 'Text',
              value: 'asdf'
            }
          },
          by_artist: [
            rock_group.merge({
              formed_on: '2023-10-01', video: [{
                '@type': 'VideoObject',
                name: 'adssad'
              }]
            })
        ]})
        result = described_class.call(obj)

        expect { result }.to_not raise_error
        expect(result).to be_considered_valid
        expect(result.to_h[:by_artist][0][:formed_on].class).to eq(Time)
      end
    end

    # TODO: needs work on edge_validator
    it 'will not validate an object with non-acceptable edge type' do
      bad_album = album.merge(by_artist: [album])

      expect(described_class.call(bad_album)).to be_considered_invalid( [:by_artist])
    end

    it 'will not validate an object with non-acceptable deeply-nested edge type' do
      bad_album = album.merge(by_artist: [rock_group.merge(video: [album])])
      subject = described_class.call(bad_album)

      expect(subject).to be_considered_invalid([:by_artist])
      expect(subject.errors.to_h[:by_artist][0][:video][0].first).to match(/MusicAlbum is not a valid type for video/)
    end
  end

  context 'real life data' do
    it 'can validate' do
      data = {
        "@type"=>"Action",
        "actor"=> {
          "@type" => "Person",
          "provider" => "lastfm",
          'provider_slug' => "hyfen",
          "name"=>"Andrew Louis",
          "url"=>"http://www.last.fm/user/hyfen"
        },
        "verb"=>"listened",
        "object"=>
        {"@type"=>"MusicRecording",
          "provider"=>"lastfm",
          "provider_id"=>"0bbc57a5-ab84-3164-8ec1-a23480621512",
          "by_artist"=>[
          {"@type"=>"MusicGroup",
            "provider"=>"lastfm",
            "name"=>"John Talabot",
            "url"=>"https://www.last.fm/music/John+Talabot"}],
          "in_album"=>[{"@type"=>"MusicAlbum", "provider"=>"lastfm", "name"=>"Fin"}],
          "name"=>"Depak Ine",
          "url"=>"https://www.last.fm/music/John+Talabot/_/Depak+Ine"},
        "end_at"=>"2023-10-27T11:54:08.000-04:00"}

      result = described_class.call(data)
      expect(described_class.call(data)).to be_considered_valid
    end
  end
end
