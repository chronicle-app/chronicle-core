require 'spec_helper'

require 'chronicle/models/generation'
Chronicle::Models::Generation.suppress_model_generation
require 'chronicle/models'

RSpec.describe Chronicle::Models::Base do
  describe '#new' do
    it 'can create a new instance with attributes' do
      expect(described_class.new(id: 'foo')).to be_a(described_class)
      expect(described_class.new(id: 'foo').properties[:id]).to eq('foo')
    end

    it 'will raise an error for attributes it does not expect' do
      expect do
        described_class.new(xyz: 'bar')
      end.to raise_error(Chronicle::Models::AttributeError)
    end

    context 'when creating with a block' do
      it 'can be created with attributes through a block' do
        expect do
          described_class.new do |c|
            c.id = 'foo'
          end
        end.to_not raise_error

        expect(described_class.new do |c|
          c.id = 'foo'
        end
        .properties[:id]).to eq('foo')
      end

      it 'will raise an error when an attribute is not expected' do
        expect do
          described_class.new do |c|
            c.xyz = 'bar'
          end
        end.to raise_error(Chronicle::Models::AttributeError)
      end
    end
  end
end
