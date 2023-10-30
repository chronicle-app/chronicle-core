require 'spec_helper'
require 'chronicle/schema/generators/generate_models'

RSpec.describe Chronicle::Schema::Generators::GenerateModels do
  let(:sample_parsed_ttl) do
    sample_ttl_path = File.join(File.dirname(__FILE__), '..', '..', '..', 'support', 'schema', 'sample.ttl')
    sample_ttl_str = File.read(sample_ttl_path)
    Chronicle::Schema::Generators::RDFParser.new(sample_ttl_str).parse

    # binding.pry
  end

  describe '#generate' do
    after do
      Chronicle.send(:remove_const, :TestSchema) if Chronicle.const_defined?(:TestSchema)
    end

    it 'should generate executable Ruby code' do
      code = described_class.new(sample_parsed_ttl, namespace: 'Chronicle::TestSchema').generate

      expect { eval(code) }.to_not raise_error
    end

    describe 'generated models' do
      before do
        code = described_class.new(sample_parsed_ttl, namespace: 'Chronicle::TestSchema').generate
        eval(code)
      end

      after do
        Chronicle.send(:remove_const, :TestSchema) if Chronicle.const_defined?(:TestSchema)
      end

      it 'should generate a model for a subclass with its parents attributes' do
        expect(Chronicle::TestSchema::Person.schema.type.map(&:name)).to include(:id, :name)
      end

      it 'does type checking on properties' do
        expect do
          Chronicle::TestSchema::Person.new(name: 1)
        end.to raise_error(Chronicle::Schema::AttributeError)
      end

      it 'enforced cardinality' do
        expect do
          Chronicle::TestSchema::Person.new(name: ['Bob', 'Alice'])
        end.to raise_error(Chronicle::Schema::AttributeError)
      end

      it 'does not allow single items for many cardinality attributes' do
        expect do
          Chronicle::TestSchema::MusicAlbum.new(by_artist: Chronicle::TestSchema::Person.new)
        end.to raise_error(Chronicle::Schema::AttributeError)
      end

      it 'ensures an array is passed for many cardinality attributes' do
        expect do
          Chronicle::TestSchema::MusicAlbum.new(by_artist: [Chronicle::TestSchema::Person.new])
        end.to_not raise_error
      end

      it 'can associate a subclass of a valid property type' do
        expect do
          Chronicle::TestSchema::Activity.new(
            verb: 'Bob',
            actor: Chronicle::TestSchema::RockGroup.new(name: 'The Beatles')
          )
        end.to_not raise_error
      end

      it 'does correct type checking on properties' do
        expect do 
          Chronicle::TestSchema::Activity.new(
            verb: 'Bob',
            actor: Chronicle::TestSchema::MusicAlbum.new
          )
        end.to raise_error(Chronicle::Schema::AttributeError)
      end

      describe 'numeric attributes' do
        
      end

      describe 'time attributes' do
        let(:activity_args) { 
          {
            verb: 'ate',
            end_at: Time.now,
            actor: Chronicle::TestSchema::Person.new
          }
         }

        it 'can handle datetime classes' do
          expect do
            Chronicle::TestSchema::Activity.new(activity_args)
          end.to_not raise_error
        end

        it 'is the right class' do
          expect(
            Chronicle::TestSchema::Activity
              .new(activity_args)
              .end_at
          ).to be_a(Time)
        end

        it 'coerces string dates correctly' do
          time_str = '2005-04-04 12:00'
          expect(
            Chronicle::TestSchema::Activity
              .new(activity_args.merge(end_at: time_str))
              .end_at
          ).to eq(Time.parse(time_str))
        end
      end
    end
  end
end
