require 'spec_helper'
require 'chronicle/schema'
require 'chronicle/schema/generators/rdf_parser'
require 'chronicle/models/generation'
Chronicle::Models::Generation.suppress_model_generation
require 'chronicle/models'

RSpec.describe Chronicle::Models::Builder do
  let(:sample_schema_classes) do
    sample_ttl_path = File.join(File.dirname(__FILE__), '..', '..', 'support', 'schema', 'sample.ttl')
    sample_ttl_str = File.read(sample_ttl_path)
    Chronicle::Schema::Generators::RDFParser.new(sample_ttl_str).parse.classes
  end

  let(:mock_module) do
    Module.new do
      extend Chronicle::Models::Builder
      include Chronicle::Models::Generation
    end
  end

  describe '.build' do
    before do
      mock_module.generate_models(sample_schema_classes)
    end

    describe 'pathological cases' do
      it 'raises an exception if the object is not a hash' do
        expect { mock_module.build('not a hash') }.to raise_error(ArgumentError)
      end

      it 'raises an exception if the object does not have a type' do
        expect { mock_module.build({}) }.to raise_error(ArgumentError)
      end

      it 'raises an exception if the object type is not a known model' do
        expect { mock_module.build({ '@type' => 'NotAModel' }) }.to raise_error(ArgumentError)
      end
    end

    describe 'unnested objects' do
      it 'can build a model from a hash' do
        obj = {
          :'@type' => 'TestOnly',
          name: 'Test'
        }
        model = mock_module.build(obj)
        expect(model).to be_a(mock_module::TestOnly)
        expect(model.name).to eq('Test')
      end

      it 'can coerce values' do
        obj = {
          '@type': 'MusicGroup',
          formed_on: '2019-01-01'
        }
        model = mock_module.build(obj)
        expect(model.formed_on).to be_a(Time)
        expect(model.formed_on).to eq(Time.parse('2019-01-01'))
      end
    end

    describe 'nested objects' do
      it 'can build a model with a nested hash' do
        obj = {
          '@type': 'Action',
          verb: 'foo',
          actor: {
            '@type': 'Person',
            name: 'John Doe'
          }
        }

        model = mock_module.build(obj)
        expect(model).to be_a(mock_module::Action)
        expect(model.actor).to be_a(mock_module::Person)
      end

      it 'can build a model with a nested array' do
        obj = {
          '@type': 'MusicAlbum',
          name: 'White Album',
          by_artist: [{
            '@type': 'MusicGroup',
            name: 'The Beatles'
          }]
        }

        model = mock_module.build(obj)
        expect(model).to be_a(mock_module::MusicAlbum)
        expect(model.by_artist[0]).to be_a(mock_module::MusicGroup)
      end

      it 'can build a model with a nested array of strings' do
        obj = {
          '@type': 'MusicAlbum',
          name: 'White Album',
          by_artist: ['The Beatles', 'The Rolling Stones']
        }
        expect { mock_module.build(obj) }.to_not raise_error
      end

      it 'will not build a model with an invalid nested value' do
        obj = {
          '@type': 'MusicAlbum',
          name: 'White Album',
          by_artist: [{
            '@type': 'MusicAlbum',
            name: 'White Album'
          }]
        }
        expect { mock_module.build(obj) }.to raise_error(ArgumentError)
      end
    end
  end
end
