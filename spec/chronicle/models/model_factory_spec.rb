require 'spec_helper'
require 'chronicle/models/generation'
Chronicle::Models::Generation.suppress_model_generation
require 'chronicle/models'

RSpec.describe Chronicle::Models::ModelFactory do
  describe '#generate' do
    let (:name_property) do
      {
          name_snake_case: :name,
          range_with_subclasses: [:Text],
          is_required: false,
          is_many: false
      }
    end

    let (:mandatory_property) do
      {
        name_snake_case: :mandatory_ages,
        range_with_subclasses: [:Integer],
        is_required: true,
        is_many: true
      }
    end

    let (:chronicle_edge) do
      {
        name_snake_case: :chronicle_edge,
        range_with_subclasses: [:FooBar],
        is_required: false,
        is_many: false
      }
    end

    let (:superclasses) do
      [:Entity, :Thing]
    end

    let (:properties_simple) do
      [name_property]
    end

    let (:properties_complex) do
      [name_property, mandatory_property]
    end

    subject { described_class.new(properties: properties_simple, superclasses: ).generate }

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
            subject.new()
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
          FooBar = described_class.new().generate

          expect do
            subject.new(chronicle_edge: FooBar.new)
          end.to_not raise_error
        end

        it 'will raise an error if the attribute is not the correct type' do
          FooBaz = described_class.new().generate

          expect do
            subject.new(chronicle_edge: FooBaz.new)
          end.to raise_error(Chronicle::Models::AttributeError)
        end
      end
    end
  end
end
