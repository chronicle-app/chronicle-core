module Chronicle::Schema::Validation
  module Generation
    @contracts_generated = false

    def self.generate_contracts(classes = Chronicle::Schema::CLASS_DATA)
      return if @contracts_generated

      Chronicle::Schema::Validation.class_data = classes

      classes.each do |name, details|
        class_name = details[:name_short]

        type_contract_class = Chronicle::Schema::Validation::ContractFactory.create(class_name:, properties: details[:properties])

        Chronicle::Schema::Validation.set_contract(class_name, type_contract_class)
      end

      @contracts_generated = true
    end
  end
end
