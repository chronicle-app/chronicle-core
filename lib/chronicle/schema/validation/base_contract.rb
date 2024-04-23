require 'dry/validation'

module Chronicle
  module Schema
    module Validation
      class BaseContract < Dry::Validation::Contract
        option :edge_validator, default: -> { Chronicle::Schema::Validation::EdgeValidator.new }

        # I think this doesn't work for nested objects because
        # we don't enumerate all the properties and rely on the edgevalidator
        # to do the validation. Commenting out for now.
        # config.validate_keys = true

        attr_accessor :type_name

        def self.type(type_name)
          @type_name = type_name
        end
      end
    end
  end
end
