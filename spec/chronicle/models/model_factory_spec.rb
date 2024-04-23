require 'spec_helper'
require 'chronicle/schema/rdf_parsing'
require 'chronicle/models/generation'
Chronicle::Models::Generation.suppress_model_generation
require 'chronicle/models'

RSpec.describe Chronicle::Models::ModelFactory do
  include_context 'with_sample_schema_graph'

  let(:root_class) do
    sample_schema_graph.find_type(:Thing)
  end

  let(:event_class) do
    sample_schema_graph.find_type(:Event)
  end

  let(:action_class) do
    sample_schema_graph.find_type(:Action)
  end

  describe '#generate' do
    context 'for a root class' do
      subject do
        described_class.new(
          type_id: root_class.short_id.to_sym,
          properties: root_class.all_properties
        ).generate
      end

      it 'can generates a class' do
        expect(subject).to be_a(Class)
        expect(subject.ancestors).to include(Chronicle::Models::Base)
      end

      it 'has expected attributes defined' do
        expect(subject.attribute_names).to include(:name)
      end

      describe 'attribute type checking' do
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
      end
    end

    context 'with a subtype' do
      let(:person_class) do
        klass = sample_schema_graph.find_type(:Person)
        described_class.new(
          type_id: klass.short_id.to_sym,
          properties: klass.all_properties
        ).generate
      end

      subject do
        described_class.new(
          type_id: action_class.short_id.to_sym,
          properties: action_class.all_properties
        ).generate
      end

      describe 'non-optional attributes' do
        it 'will raise an error if the attribute is not present' do
          expect do
            subject.new
          end.to raise_error(Chronicle::Models::AttributeError)
        end

        it 'will accept the correct type' do
          expect do
            subject.new(agent: person_class.new)
          end.to_not raise_error
        end

        it 'will raise an error if the attribute is not the correct cardinality' do
          expect do
            subject.new(agent: [person_class.new])
          end.to raise_error(Chronicle::Models::AttributeError)
        end

        it 'will raise an error if the attribute is not the correct type' do
          root = described_class.new(
            type_id: root_class.short_id.to_sym,
            properties: root_class.all_properties
          ).generate

          expect do
            subject.new(agent: root.new)
          end.to raise_error(Chronicle::Models::AttributeError)
        end

        it 'will raise an error if the attribute is array of nil' do
          expect do
            subject.new(agent: nil)
          end.to raise_error(Chronicle::Models::AttributeError)
        end
      end
    end
  end
end
