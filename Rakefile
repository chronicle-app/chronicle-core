# frozen_string_literal: true

require "bundler/gem_tasks"
task default: %i[]


namespace :generate do
  desc 'Generate Ruby classes from TTL file'
  task :classes, [:ttl_path] do |t, args|
    require_relative 'lib/chronicle/schema/generator'
    require 'pry'
    ttl_path = args[:ttl_path] || File.join(File.dirname(__FILE__), 'lib', 'chronicle', 'schema', 'data', 'schema.ttl')
    generator = Chronicle::Schema::Generator.new(ttl_path)
    generator.generate!
  end
end
