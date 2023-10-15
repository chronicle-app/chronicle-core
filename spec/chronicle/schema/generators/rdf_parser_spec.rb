require 'spec_helper'
require 'chronicle/schema/generators/rdf_parser'

RSpec.describe Chronicle::Schema::Generators::RDFParser do
  let(:sample_ttl_path) do
    File.join(File.dirname(__FILE__), '..', '..', '..', 'support', 'schema','sample.ttl')
  end

  let(:sample_ttl_str) do
    File.read(sample_ttl_path)
  end

  let(:sample_parsed_ttl) do
    described_class.new(sample_ttl_str).parse
  end

  describe '#parse' do
    it 'should parse a sample ttl string and not raise errors' do
      expect { sample_parsed_ttl }.to_not raise_error
    end
  end

  describe '#graph' do
    it 'should return an RDF::Graph' do
      expect(sample_parsed_ttl.graph).to be_a(RDF::Graph)
    end
  end

  describe '#properties' do
    it 'should be an array' do
      expect(sample_parsed_ttl.properties).to be_a(Array)
    end

    it 'should should be able to handle subchild properties' do
      properties = sample_parsed_ttl.properties
      by_artist_property = properties.find { |p| p[:name_shortened] == 'byArtist' }
      expect(by_artist_property[:range_with_subclasses]).to include('https://schema.chronicle.app/MusicGroup')
    end

    it 'can deduce correct cardinality' do
      properties = sample_parsed_ttl.properties
      name_property = properties.find { |p| p[:name_shortened] == 'name' }
      expect(name_property[:cardinality]).to eq(:zero_or_one)
    end
  end

  describe '#classes' do
    it 'should be a hash' do
      expect(sample_parsed_ttl.classes).to be_a(Hash)
      expect(sample_parsed_ttl.classes.keys).to include('https://schema.chronicle.app/MusicAlbum')
    end

    it 'is topologically sorted' do
      position_of_entity = sample_parsed_ttl.classes.keys.index('https://schema.chronicle.app/Entity')
      position_of_music_album = sample_parsed_ttl.classes.keys.index('https://schema.chronicle.app/RockGroup')
      expect(position_of_entity).to be < position_of_music_album
    end
  end
end
