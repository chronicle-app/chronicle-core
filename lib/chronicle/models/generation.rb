require 'chronicle/schema'
require_relative 'model_factory'
require_relative 'base'

module Chronicle::Models
  module Generation
    @models_generated = false
    @benchmark_enabled = false

    class << self
      attr_accessor :models_generated, :benchmark_enabled
    end

    def self.included(base)
      base.extend ClassMethods
      base.generate_models unless base.models_generated?
    end

    # Methods for generating models from the schema
    module ClassMethods
      def models_generated?
        Chronicle::Models::Generation.models_generated
      end

      def extant_models
        constants.select do |constant_name|
          constant = const_get(constant_name)
          constant.is_a?(Class) && constant.superclass == Chronicle::Models::Base
        end
      end

      def generate_models(graph = nil)
        graph ||= begin
          require 'json'
          require 'chronicle/schema/rdf_parsing'
          schema_path = File.join(File.dirname(__FILE__), '..', '..', '..', 'schema', 'chronicle_schema_v1.json')
          Chronicle::Schema::SchemaGraph.build_from_json(JSON.parse(File.read(schema_path)))
        end

        start_time = Time.now
        graph.classes.each do |klass|
          class_id = graph.id_to_identifier(klass.id)

          new_model_klass = Chronicle::Models::ModelFactory.new(
            type_id: class_id.to_sym,
            properties: klass.all_properties,
            superclasses: klass.ancestors.map(&:short_id).map(&:to_sym)
          ).generate

          const_set(class_id, new_model_klass)
        end
        end_time = Time.now
        duration_ms = (end_time - start_time) * 1000
        handle_benchmark_data(classes.length, duration_ms) if Chronicle::Models::Generation.benchmark_enabled

        Chronicle::Models::Generation.models_generated = true
      end

      def unload_models
        constants.each do |constant_name|
          constant = const_get(constant_name)
          send(:remove_const, constant_name) if constant.is_a?(Class) && constant.superclass == Chronicle::Models::Base
        end
        Chronicle::Models::Generation.models_generated = false
      end

      def enable_benchmarking
        Chronicle::Models::Generation.benchmark_enabled = true
      end

      private

      def handle_benchmark_data(number_of_models, duration)
        puts "Generated #{number_of_models} models in #{duration.round(2)}ms"
      end
    end

    def self.reset
      Chronicle::Models::Generation.models_generated = false
    end

    def self.suppress_model_generation
      Chronicle::Models::Generation.models_generated = true
    end
  end
end
