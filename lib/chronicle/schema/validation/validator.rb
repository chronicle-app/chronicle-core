module Chronicle::Schema::Validation
  class Validator
    def validate(data)
      type = data[:@type]
      contract = Chronicle::Schema::Validation.get_contract(type)

      raise Chronicle::Schema::ValidationError, "No contract found for type #{type}" unless contract

      result = contract.new.call(data)
      result
    end

    def self.call(data)
      new.validate(data)
    end
  end
end
