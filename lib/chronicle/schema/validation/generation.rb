module Chronicle::Schema::Validation
  module Generation
    @contracts_generated = false

    def self.generate_contracts(classes = Chronicle::Schema::CLASS_DATA)
      return if @contracts_generated

      Chronicle::Schema::Validation.class_data = classes

      classes.each do |class_id, details|
        type_contract_class = Chronicle::Schema::Validation::ContractFactory.create(class_id:, properties: details[:properties])

        Chronicle::Schema::Validation.set_contract(class_id, type_contract_class)
      end

      @contracts_generated = true
    end
  end
end
