module Chronicle
  module Schema
    module Validation
      class ContractFactory
        def self.process_errors(errors)
          messages = []
          errors.each do |key, value|
            base_path = key == :base ? [] : [key]
            if value.is_a?(Hash)
              value.each do |k, v|
                messages << [base_path + [k], v.first.to_s]
              end
            elsif value.is_a?(Array)
              messages << [base_path, value.first.to_s]
            else
              messages << [base_path, value.to_s]
            end
          end
          messages
        end

        def self.create(type_id:, properties: [])
          Class.new(Chronicle::Schema::Validation::BaseContract) do
            type type_id

            params(Chronicle::Schema::Validation::ContractFactory.create_schema(type_id:, properties:))

            properties.each do |property|
              edge_name = property.id_snakecase

              if property.many?
                rule(edge_name).each do |index:|
                  errors = edge_validator.validate(type_id, edge_name, value)

                  error_path = [edge_name, index]
                  messages = Chronicle::Schema::Validation::ContractFactory.process_errors(errors)
                  messages.each do |path, message|
                    key(error_path + path).failure(message)
                  end
                end
              else
                rule(edge_name) do
                  # handle nils. FIXME: this is a hack
                  next unless value

                  errors = edge_validator.validate(type_id, edge_name, value)
                  error_path = [edge_name]
                  messages = Chronicle::Schema::Validation::ContractFactory.process_errors(errors)
                  messages.each do |path, message|
                    key(error_path + path).failure(message)
                  end
                end
              end
            end
          end
        end

        def self.create_schema(type_id:, properties: [])
          Dry::Schema.JSON do
            required(:@type).value(:str?).filled(eql?: type_id.to_s)

            before(:key_coercer) do |result|
              result.to_h.transform_keys!(&:to_sym)

              valid_property_ids = properties.map(&:id_snakecase)
              valid_property_ids << :@type
              invalid_properties = result.to_h.keys - valid_property_ids

              invalid_properties.each do |invalid_property|
                result.add_error([:unexpected_key, [invalid_property.to_sym, []]])
              end
            end

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
              property_name = property.id_snakecase
              type = Chronicle::Schema::Validation::ContractFactory.build_type(property.range_identifiers)

              outer_macro = property.required? ? :required : :optional

              if property.many?
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
  end
end
