module Chronicle::Schema::Validation
  module Generation
    @contracts_generated = false

    def self.generate_contracts(graph)
      return if @contracts_generated

      @graph = graph

      graph.classes.each do |klass|
        class_id = klass.short_id.to_sym
        type_contract_class = Chronicle::Schema::Validation::ContractFactory.create(class_id:,
          properties: klass.all_properties)

        Chronicle::Schema::Validation.set_contract(class_id, type_contract_class)
      end

      @contracts_generated = true
    end

    def self.graph
      @graph
    end
  end
end
