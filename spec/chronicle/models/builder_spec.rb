require 'spec_helper'
require 'chronicle/schema'
require 'chronicle/models/generation'
Chronicle::Models::Generation.suppress_model_generation
require 'chronicle/models'

RSpec.describe Chronicle::Models::Builder do
  include_context 'with_sample_schema_graph'

  describe '.build' do
    describe 'pathological cases' do
      it 'raises an exception if the object is not a hash' do
        expect { sample_model_module.build('not a hash') }.to raise_error(ArgumentError)
      end

      it 'raises an exception if the object does not have a type' do
        expect { sample_model_module.build({}) }.to raise_error(ArgumentError)
      end

      it 'raises an exception if the object type is not a known model' do
        expect { sample_model_module.build({ '@type' => 'NotAModel' }) }.to raise_error(ArgumentError)
      end
    end

    describe 'unnested objects' do
      it 'can build a model from a hash' do
        obj = {
          '@type': 'Thing',
          name: 'Test'
        }
        model = sample_model_module.build(obj)
        expect(model).to be_a(sample_model_module::Thing)
        expect(model.name).to eq('Test')
      end

      it 'can coerce values' do
        obj = {
          '@type': 'Event',
          end_date: '2019-01-01'
        }
        model = sample_model_module.build(obj)
        expect(model.end_date).to be_a(Time)
        expect(model.end_date).to eq(Time.parse('2019-01-01'))
      end
    end

    describe 'nested objects' do
      it 'can build a model with a nested hash' do
        obj = {
          '@type': 'Action',
          agent: {
            '@type': 'Person',
            name: 'John Doe'
          }
        }

        model = sample_model_module.build(obj)
        expect(model).to be_a(sample_model_module::Action)
        expect(model.agent).to be_a(sample_model_module::Person)
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

        # binding.pry
        model = sample_model_module.build(obj)
        expect(model).to be_a(sample_model_module::MusicAlbum)
        expect(model.by_artist[0]).to be_a(sample_model_module::MusicGroup)
      end

      # TODO: handle strings as alternatives to hashes
      xit 'can build a model with a nested array of strings' do
        obj = {
          '@type': 'MusicAlbum',
          name: 'White Album',
          by_artist: ['The Beatles', 'The Rolling Stones']
        }
        expect { sample_model_module.build(obj) }.to_not raise_error
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
        expect { sample_model_module.build(obj) }.to raise_error(ArgumentError)
      end
    end
  end
end
