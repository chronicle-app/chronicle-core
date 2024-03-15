# frozen_string_literal: true

require 'bundler/gem_tasks'
task default: %i[]

namespace :generate do
  DEFAULT_SCHEMA_FILE = File.join(File.dirname(__FILE__), 'lib', 'chronicle', 'schema', 'data', 'schema.ttl')

  desc 'Generate everything'
  task :all, :version do |_t, args|
    version = args[:version] || latest_version
    Rake::Task['generate:generate'].invoke(version)
    Rake::Task['generate:cache_schema'].invoke(version)
    # Rake::Task['generate:test'].invoke(version)
  end

  desc 'Generate schema'
  task :generate, :version do |_t, args|
    require 'pry'
    require 'chronicle/schema'
    require 'chronicle/schema/rdf_parsing'
    require 'json'

    version = args[:version] || latest_version
    puts "Generating schema with version: #{version}"

    schema_dsl_file = File.join(File.dirname(__FILE__), 'schema', "chronicle_schema_v#{version}.rb")

    graph = Chronicle::Schema::RDFParsing::Schemaorg.build_graph

    new_graph = Chronicle::Schema::RDFParsing::GraphTransformer.transform_from_file(graph, :Thing, schema_dsl_file)

    ttl_str = Chronicle::Schema::RDFParsing::RDFSerializer.serialize(new_graph)
    output_filename = schema_dsl_file.gsub(/\.rb$/, '.ttl')

    File.write(output_filename, ttl_str)
  end

  desc 'Cache schema from ttl file'
  task :cache_schema, :version do |_t, args|
    require 'chronicle/schema'
    require 'chronicle/schema/rdf_parsing'

    version = args[:version] || latest_version
    puts "Caching schema with version: #{version}"

    ttl_file = File.join(File.dirname(__FILE__), 'schema', "chronicle_schema_v#{version}.ttl")
    graph = Chronicle::Schema::RDFParsing::TTLGraphBuilder.build_from_file(ttl_file)

    output_filename = File.join(File.dirname(__FILE__), 'schema',
      "chronicle_schema_v#{version}.json")

    output_str = JSON.pretty_generate(graph.to_h)

    File.write(output_filename, output_str)
  end

  # desc 'test'
  # task :test, :version do |_t, args|
  #   require 'chronicle/models'
  #   binding.pry
  # end

  # Highest version schema file in schema/ directory
  def latest_version
    schema_files = Dir.glob(File.join(File.dirname(__FILE__), 'schema', 'chronicle_schema_v*.rb'))
    versions = schema_files.map { |f| f.match(/chronicle_schema_v(.*)\.rb/)&.captures&.first }
    sorted_versions = versions.sort_by { |version| Gem::Version.new(version) }
    sorted_versions.last
  end
end

task :generate, :version do |_t, args|
  Rake::Task['generate:all'].invoke(args[:version])
end
