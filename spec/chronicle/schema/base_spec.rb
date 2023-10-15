require 'spec_helper'

RSpec.describe Chronicle::Schema::Base do
  describe '#new' do
    it 'can create a new instance with attributes' do
      expect(described_class.new(id: 'foo')).to be_a(described_class)
      expect(described_class.new(id: 'foo').properties).to eq(id: 'foo')
    end

    it 'will raise an error for attributes it does not expect' do
      expect do
        described_class.new(xyz: 'bar')
      end.to raise_error(Chronicle::Schema::AttributeError)
    end
  end
end
