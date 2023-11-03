require 'chronicle/schema/data/data'
require_relative 'model_factory'
require_relative 'base'

module Chronicle::Models
  module Generation
    @models_generated = false

    class << self
      attr_accessor :models_generated
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

      def generate_models(classes = Chronicle::Schema::CLASS_DATA)
        start_time = Time.now
        classes.each do |class_id, details|
          new_model_klass = Chronicle::Models::ModelFactory.new(details[:properties]).generate

          const_set(class_id, new_model_klass)
        end
        end_time = Time.now
        # puts "Generated #{classes.length} models in ms: #{(end_time - start_time) * 1000}"

        Chronicle::Models::Generation.models_generated = true
      end

      def unload_models
        constants.each do |constant_name|
          constant = const_get(constant_name)
          send(:remove_const, constant_name) if constant.is_a?(Class) && constant.superclass == Chronicle::Models::Base
        end
        Chronicle::Models::Generation.models_generated = false
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
