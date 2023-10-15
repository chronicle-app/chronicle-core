require 'spec_helper'
require 'chronicle/schema/generators/generate_schema_validators'

RSpec.describe Chronicle::Schema::Generators::GenerateSchemaValidators do
  let(:sample_parsed_ttl) do
    sample_ttl_path = File.join(File.dirname(__FILE__), '..', '..', '..', 'support', 'schema','sample.ttl')
    sample_ttl_str = File.read(sample_ttl_path)
    Chronicle::Schema::Generators::RDFParser.new(sample_ttl_str).parse

    # binding.pry
  end

  describe '#generate' do
    after do
      Chronicle::Schema.send(:remove_const, :TestValidator) if Chronicle::Schema.const_defined?(:TestValidator)
    end

    it 'should generate executable Ruby code' do
      code = described_class.new(sample_parsed_ttl, namespace: 'Chronicle::Schema::TestValidator').generate
      expect { eval(code) }.to_not raise_error
    end
  end

  describe 'generated validators' do
    require 'chronicle/schema'
    before do
      code = described_class.new(sample_parsed_ttl, namespace: 'Chronicle::Schema::TestValidator').generate
      eval(code)
    end

    after do
      Chronicle::Schema.send(:remove_const, :TestValidator) if Chronicle::Schema.const_defined?(:TestValidator)
    end

    it 'should generate a validator for a subclass with its parents attributes' do
      expect(Chronicle::Schema::TestValidator::PersonSchema).to_not be_nil
    end

    it 'should be able to build a basic object' do
      sample = {
        '@type': "Person",
        name: 'dsafdas'
      }
      result = Chronicle::Schema::TestValidator::PersonSchema.call(sample)
      expect(result.errors.to_h).to eql({})
    end

    it 'should be able to handle nested text values' do
      sample = {
        '@type': "Person",
        name: {
          '@type': 'Text',
          value: 'hi there'
        }
      }
      result = Chronicle::Schema::TestValidator::PersonSchema.call(sample)
      expect(result.errors.to_h).to eql({})
    end

    it 'should fail without a valid type' do
      sample = {
        '@type': 'Foo'
      }

      expect(
        Chronicle::Schema::TestValidator::PersonSchema.call(sample).errors
      ).to_not be_empty
    end

    it 'should reject non-array edges for many cardinality' do
      expect(Chronicle::Schema::TestValidator::MusicAlbumSchema.call({
        '@type': 'MusicAlbum',
        by_artist: {
          '@type': 'MusicGroup',
          name: 'The Beatles'
        }
      })).to_not be_success
    end

    it 'should reject an incorrect type' do
      expect(Chronicle::Schema::TestValidator::MusicAlbumSchema.call({
        '@type': 'MusicAlbum',
        by_artist: [{
          '@type': 'XXX',
          name: 'The Beatles'
        }]
      })).to_not be_success
    end

    it 'should accept an array of strings for many cardinality' do
      expect(Chronicle::Schema::TestValidator::MusicAlbumSchema.call({
        '@type': 'MusicAlbum',
        by_artist: ['The Beatles', 'The Rolling Stones']
      })).to be_success
    end

    it 'should not accept nil in array for many cardinality' do
      expect(Chronicle::Schema::TestValidator::MusicAlbumSchema.call({
        '@type': 'MusicAlbum',
        by_artist: [nil]
      })).to_not be_success
    end

    it 'should test schema' do
      sample = {
        '@type': 'MusicAlbum',
        by_artist: [{
          '@type': 'MusicGroup',
          name: 'The Beatles'
        }]
      }
      module Types
        include Dry.Types()
      end

      t = Types::String | Types::Hash.schema(name: Types::String, age: Types::Coercible::Integer)
      a = Types::Array.of(Types::Coercible::String)

      TestSchema = Dry::Schema.Params do
        # doesn't work. seems to accept any hash
        # required(:by_artist).value(:array).each(t)

        # doesn't work
        # required(:by_artist).value(a)

        # works for non-arrays
        # required(:by_artist) { str? | hash { required(:bar).filled } }

        # works for non-arrays
        # required(:by_artist) { str? | hash(Chronicle::Schema::TestValidator::MusicAlbumSchema) }

        # works
        # required(:by_artist) do
        #   array? & each do
        #     str?
        #   end
        # end

        optional(:by_artist) do
          str? | array? & each do
            str?  |
              hash(Chronicle::Schema::TestValidator::MusicGroupSchema) |
              hash(Chronicle::Schema::TestValidator::RockGroupSchema)
          end
        end
      end

      expect(TestSchema.call({
      })).to be_success

      expect(TestSchema.call({
        by_artist: nil
      })).to_not be_success

      expect(TestSchema.call({
        by_artist: [nil]
      })).to_not be_success

      expect(TestSchema.call({
        by_artist: ['asdfa']
      })).to be_success

      expect(TestSchema.call({
        by_artist: [{
          '@type': 'MusicGroup',
          name: 'The Beatles'
        }]
      })).to be_success

      expect(TestSchema.call({
        by_artist: [{
          '@type': 'RockGroup',
          name: 'The Beatles'
        }]
      })).to be_success
      
      expect(TestSchema.call({
        by_artist: [{
          '@type': 'Entity',
          name: 'The Beatles'
        }]
      })).to_not be_success
      
      expect(TestSchema.call({
        by_artist: [{
          '@type': 'MusicGroup',
          name: 4
        }]
      })).to_not be_success

      expect(TestSchema.call({
        by_artist: [4]
      })).to_not be_success
      
      expect(TestSchema.call({
        by_artist: [nil]
      })).to_not be_success

      expect(TestSchema.call({
        by_artist: 'asdfa'
      })).to be_success
      

      # x = Chronicle::Schema::TestValidator::MusicAlbumSchema.call(sample)
      # binding.pry

      expect(
        Chronicle::Schema::TestValidator::MusicAlbumSchema.call(sample)
      ).to be_success
    end
  end
end
