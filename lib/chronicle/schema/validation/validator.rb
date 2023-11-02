module Chronicle::Schema::Validation
  class Validator
    def validate(data)
      type = data[:@type] || data['@type']
      raise Chronicle::Schema::ValidationError, "Data does not contain a typed object" unless type
      
      contract = Chronicle::Schema::Validation.get_contract(type.to_sym)

      # binding.pry unless contract
      raise Chronicle::Schema::ValidationError, "#{type} is not a valid type" unless contract

      result = contract.new.call(data)
      result
    end

    def self.call(data)
      new.validate(data)
    end
  end
end
