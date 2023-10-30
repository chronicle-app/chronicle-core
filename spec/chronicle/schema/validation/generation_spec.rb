require 'spec_helper'
# require 'chronicle/schema/validation'
require 'chronicle/schema/generators/rdf_parser'

RSpec.describe Chronicle::Schema::Validation::Generation do
  # TODO: share this with other specs
  let (:schema_class_data) do
    sample_ttl_path = File.join(File.dirname(__FILE__), '..', '..', '..', 'support', 'schema','sample.ttl')
    sample_ttl_str = File.read(sample_ttl_path)
    Chronicle::Schema::Generators::RDFParser.new(sample_ttl_str).parse.classes
  end

  it 'can build a schema' do
    Chronicle::Schema::Validation::Generation.generate_contracts(schema_class_data)

    contract = Chronicle::Schema::Validation.get_contract(:Person)
    expect(contract).to_not be_nil
    expect(contract.new).to respond_to(:call)
    expect(contract.new.call({}).success?).to be_falsey
  end
end
