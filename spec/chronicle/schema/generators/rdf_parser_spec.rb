require 'spec_helper'
require 'chronicle/schema'
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

  context 'after successful parsing of a ttl file' do
    subject { described_class.parse_ttl_file(sample_ttl_path) }

    it 'should return an RDF::Graph' do
      expect(subject.graph).to be_a(RDF::Graph)
    end

    describe "#classes" do
      it 'should be a hash' do
        expect(subject.classes).to be_a(Hash)
        expect(subject.classes.keys).to include(:MusicAlbum)
      end

      it 'should deduce correct subclasses' do
        expect(subject.classes[:MusicGroup][:subclasses]).to include(:RockGroup)
      end

      it 'should deduce correct superclasses' do
        expect(subject.classes[:RockGroup][:superclasses]).to include(:MusicGroup)
        expect(subject.classes[:RockGroup][:superclasses]).to include(:Entity)
      end

      it 'should have properties of its superclass' do
        rock_group_properties = subject.classes[:RockGroup][:properties].map { |p| p[:id] }
        expect(rock_group_properties).to include(:name)
      end
    end

    describe '#properties' do
      it 'should be an array' do
        expect(subject.properties).to be_a(Array)
      end

      it 'should should be able to handle subchild properties' do
        properties = subject.properties
        by_artist_property = properties.find { |p| p[:id] == :byArtist }
        expect(by_artist_property[:range_with_subclasses]).to include(:MusicGroup)
      end

      it 'should know about correct types for a property' do
        hair_length_property = subject.properties.find { |p| p[:id] == :hairLength }
        expect(hair_length_property[:range_with_subclasses]).to include(:Integer)
      end

      it 'should get snake cases right' do
        properties = subject.properties
        by_artist_property = properties.find { |p| p[:id] == :byArtist }
        expect(by_artist_property[:name_snake_case]).to eq(:by_artist)
      end

      it 'can deduce correct cardinality for single fields' do
        properties = subject.properties
        name_property = properties.find { |p| p[:id] == :description }
        expect(name_property[:is_required]).to eq(false)
        expect(name_property[:is_many]).to eq(false)
      end

      it 'can deduce cardinality for single required fields' do
        properties = subject.properties
        name_property = properties.find { |p| p[:id] == :agent }
        expect(name_property[:is_required]).to eq(true)
        expect(name_property[:is_many]).to eq(false)
      end

      it 'can deduce correct cardinality for required singles' do
        properties = sample_parsed_ttl.properties
        name_property = properties.find { |p| p[:id] == :agent }
        expect(name_property[:is_required]).to eq(true)
        expect(name_property[:is_many]).to eq(false)
      end
    end
  end
end
