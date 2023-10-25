require 'dry/validation'

module Chronicle::Schema::Validation
  class BaseContract < Dry::Validation::Contract
    option :edge_validator, default: -> { Chronicle::Schema::Validation::EdgeValidator.new }

    attr_accessor :type_name
    def self.type(type_name)
      @type_name = type_name
    end
  end
end
