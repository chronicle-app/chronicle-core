require 'spec_helper'
require 'chronicle/schema'
# require 'chronicle/schema/rdf_parsing'
# require 'chronicle/schema/generators/rdf_parser'

require 'chronicle/models/generation'
Chronicle::Models::Generation.suppress_model_generation
require 'chronicle/models'

RSpec.describe Chronicle::Models::Generation do
  include_context 'with_sample_schema_graph'

  let(:test_module) do
    Module.new do
      include Chronicle::Models::Generation
    end
  end

  # the suppress_model_generation at the top of this spec file is being tested
  # here a bit clumsily. This is because we can only require this module once
  it 'does not have models loaded in this spec' do
    expect(Chronicle::Models::Generation.models_generated).to be_truthy
    expect(Chronicle::Models.constants).to_not include(:MusicGroup)
  end

  it 'automatically builds models by default' do
    Chronicle::Models::Generation.reset
    expect(Chronicle::Models::Generation.models_generated).to be_falsey

    expect(test_module.models_generated?).to be_truthy
    expect(test_module.constants).to include(:MusicGroup)
  end

  describe '#unload_models' do
    it 'can generated models' do
      Chronicle::Models::Generation.reset
      expect(test_module.models_generated?).to be_truthy

      expect(test_module.constants).to include(:MusicGroup)
      test_module.unload_models
      expect(test_module.models_generated?).to be_falsey
      expect(test_module.constants).to_not include(:MusicGroup)
    end
  end

  describe '#generate_models' do
    it 'can be used to manually generate models' do
      Chronicle::Models::Generation.suppress_model_generation
      expect(test_module.extant_models).to be_empty

      test_module.generate_models(sample_schema_graph)
      expect(test_module.models_generated?).to be_truthy
      expect(test_module.extant_models).to_not be_empty
      expect(test_module.extant_models).to include(:Event)

      test_only = test_module.const_get(:Event)
      expect(test_only).to be_a(Class)
      expect(test_only.superclass).to eq(Chronicle::Models::Base)
      expect(test_only.new(name: 'foo').name).to eq('foo')

      # TODO: figure out where to put this sort of test
      t = test_module::Action.new({
        agent: test_module::Person.new(name: 'John Doe'),
        object: test_module::MusicAlbum.new(name: 'Test')
      })
      expect { t.agent.name }.to_not raise_error
    end
  end
end
