require 'spec_helper'
require 'chronicle/models/generation'
Chronicle::Models::Generation.suppress_model_generation
require 'chronicle/models'
require 'chronicle/serialization'

RSpec.describe Chronicle::Serialization::Serializer do
  describe '#initialize' do
    it 'creates a new instance of the serializer' do
      expect do
        Chronicle::Serialization::Serializer.new(Chronicle::Serialization::Record.new)
      end.not_to raise_error
    end

    it 'raises an error if the record is not a Chronicle Model' do
      expect do
        Chronicle::Serialization::Serializer.new(Object.new)
      end.to raise_error(ArgumentError)
    end
  end

  describe '#serializable_hash' do
    it 'is not implemented in base serializer' do
      expect do
        Chronicle::Serialization::Serializer.serialize(Chronicle::Serialization::Record.new)
      end.to raise_error(NotImplementedError)
    end
  end
end
