# frozen_string_literal: true

require "bundler/gem_tasks"
task default: %i[]


namespace :generate do
  DEFAULT_SCHEMA_FILE = File.join(File.dirname(__FILE__), 'lib', 'chronicle', 'schema', 'data', 'schema.ttl')

  desc 'Generate Ruby classes from TTL file'
  task :models, [:ttl_path] do |t, args|
    require_relative 'lib/chronicle/schema'
    require_relative 'lib/chronicle/schema/generators/generate_models'

    ttl_path = args[:ttl_path] || DEFAULT_SCHEMA_FILE
    output = Chronicle::Schema::Generators::GenerateModels.generate_from_ttl_path(ttl_path)

    output_path = File.join(File.dirname(__FILE__), 'lib', 'chronicle', 'schema', 'models.rb')
    File.open(output_path, 'w') { |f| f.write(output) }
  end

  desc 'Generate Ruby validators from TTL file'
  task :schema_validators, [:ttl_path] do |t, args|
    require_relative 'lib/chronicle/schema'
    require_relative 'lib/chronicle/schema/generators/generate_schema_validators'

    ttl_path = args[:ttl_path] || DEFAULT_SCHEMA_FILE
    output = Chronicle::Schema::Generators::GenerateSchemaValidators.generate_from_ttl_path(ttl_path)

    output_path = File.join(File.dirname(__FILE__), 'lib', 'chronicle', 'schema', 'schema_validators.rb')
    File.open(output_path, 'w') { |f| f.write(output) }
  end
end
