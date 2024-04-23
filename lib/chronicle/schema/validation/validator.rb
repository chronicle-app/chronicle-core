module Chronicle
  module Schema
    module Validation
      class Validator
        def validate(data)
          type = data[:@type] || data['@type']
          raise Chronicle::Schema::ValidationError, 'Data does not contain a typed object' unless type

          contract = Chronicle::Schema::Validation.get_contract(type.to_sym)

          # binding.pry unless contract
          raise Chronicle::Schema::ValidationError, "#{type} is not a valid type" unless contract

          contract.new.call(data)
        end

        def self.call(data)
          new.validate(data)
        end
      end
    end
  end
end
