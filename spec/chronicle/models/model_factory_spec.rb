require 'spec_helper'
require 'chronicle/schema/rdf_parsing'
require 'chronicle/models/generation'
Chronicle::Models::Generation.suppress_model_generation
require 'chronicle/models'

RSpec.describe Chronicle::Models::ModelFactory do
  describe '#generate' do
    let(:name_property) do
      r = Chronicle::Schema::SchemaProperty.new('https://schema.org/name')
      r.domain = ['https://schema.org/Thing']
      r.range = ['https://schema.org/Text']
      r
    end

    let(:mandatory_property) do
      r = Chronicle::Schema::SchemaProperty.new('https://schema.org/mandatoryAges')
      r.range = ['https://schema.org/Integer']
      r.required = true
      r.many = true
      r
    end

    let(:chronicle_edge) do
      r = Chronicle::Schema::SchemaProperty.new('https://schema.org/chronicle_edge')
      r.range = ['https://schema.org/FooBar']
      r.required = false
      r.many = false
      r
    end

    let(:superclasses) do
      %i[Thing]
    end

    let(:properties_simple) do
      [name_property]
    end

    let(:properties_complex) do
      [name_property, mandatory_property]
    end

    subject { described_class.new(properties: properties_simple, superclasses:).generate }

    it 'can generates a class' do
      expect(subject).to be_a(Class)
      expect(subject.ancestors).to include(Chronicle::Models::Base)
    end

    it 'has expected attributes defined' do
      expect(subject.attribute_names).to include(:name)
    end

    it 'has the correct superclasses' do
      expect(subject.superclasses).to eq(superclasses)
    end

    describe 'attribute type checking' do
      subject { described_class.new(properties: properties_simple).generate }

      it 'will accept the correct type' do
        expect do
          subject.new(name: 'foo')
        end.to_not raise_error
      end

      it 'will raise an error if the attribute is not the correct cardinality' do
        expect do
          subject.new(name: ['bar'])
        end.to raise_error(Chronicle::Models::AttributeError)
      end

      it 'will raise an error if the attribute is not the correct type' do
        expect do
          subject.new(name: 1)
        end.to raise_error(Chronicle::Models::AttributeError)
      end

      describe 'non-optional attributes' do
        subject { described_class.new(properties: properties_complex).generate }

        it 'will raise an error if the attribute is not present' do
          expect do
            subject.new
          end.to raise_error(Chronicle::Models::AttributeError)
        end

        it 'will accept the correct type' do
          expect do
            subject.new(mandatory_ages: [1, 2, 3])
          end.to_not raise_error
        end

        it 'will raise an error if the attribute is nil' do
          expect do
            subject.new(mandatory_ages: nil)
          end.to raise_error(Chronicle::Models::AttributeError)
        end
      end

      describe 'chronicle edge checking' do
        subject { described_class.new(properties: [chronicle_edge]).generate }

        it 'will accept the correct type' do
          FooBar = described_class.new.generate

          expect do
            subject.new(chronicle_edge: FooBar.new)
          end.to_not raise_error
        end

        it 'will raise an error if the attribute is not the correct type' do
          FooBaz = described_class.new.generate

          expect do
            subject.new(chronicle_edge: FooBaz.new)
          end.to raise_error(Chronicle::Models::AttributeError)
        end
      end
    end
  end
end
