module Chronicle::Schema::Validation
  class ContractFactory
    def self.create(class_id:, properties: [])
      Class.new(Chronicle::Schema::Validation::BaseContract) do
        type class_id

        params(Chronicle::Schema::Validation::ContractFactory.create_schema(class_id:, properties:))

        properties.each do |property|
          edge_name = property[:name_snake_case].to_sym

          if property[:many?]
            rule(edge_name).each do |index:|
              errors = edge_validator.validate(class_id, edge_name, value)

              errors.each do |key, value|
                if key == :base
                  key([edge_name, index]).failure(value.to_s)
                else
                  key([edge_name, index, key]).failure(value.to_s)
                end
              end
            end
          else
            rule(edge_name) do
              # handle nils. FIXME: this is a hack
              next unless value
              errors = edge_validator.validate(class_id, edge_name, value)
              errors.each do |key, value|
                if key == :base
                  key(edge_name).failure(value.to_s)
                else
                  key([edge_name, key]).failure(value.to_s)
                end
              end
            end
          end
        end
      end
    end

    def self.create_schema(class_id:, properties: [])
      Dry::Schema.JSON do
        required(:@type).value(:str?).filled(eql?: class_id.to_s)

        # Attempt to coerce chronicle edges recursively
        # I tried to use a custom type in the schema and use the constructor
        # method to do the coercion but it didn't work consistently
        before(:value_coercer) do |obj|
          obj.to_h.transform_values do |value|
            case value
            when ::Array
              value.map do |v|
                Chronicle::Schema::Validation::ContractFactory.coerce_chronicle_edge(v)
              end
            when ::Hash
              Chronicle::Schema::Validation::ContractFactory.coerce_chronicle_edge(value)
            else
              value
            end
          end
        end

        properties.each do |property|
          property_name = property[:name_snake_case].to_sym
          type = Chronicle::Schema::Validation::ContractFactory.build_type(property[:range_with_subclasses])

          outer_macro = property[:required?] ? :required : :optional

          if property[:many?]
            send(outer_macro, property_name).value(:array).each(type)
          else
            send(outer_macro, property_name).value(type)
          end
        end
      end
    end

    def self.coerce_chronicle_edge(value)
      return value unless value.is_a?(Hash)

      type = (value[:@type] || value['@type']).to_sym
      contract_klass = Chronicle::Schema::Validation.get_contract(type)
      return value unless contract_klass

      result = contract_klass.schema.call(value)
      result.success? ? result.to_h : value
    end

    def self.build_type(range)
      literals = []
      literals << :integer if range.include?(:Integer)
      literals << :float if range.include?(:Float)
      literals << :string if range.include?(:Text)
      literals << :string if range.include?(:URL)
      literals << :time if range.include?(:DateTime)

      literals << :hash
      # puts "building type for #{range}. literals: #{literals}"
      literals.uniq
    end
  end
end
