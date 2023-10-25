module Chronicle::Schema::Validation
  class ContractFactory
    def self.create(class_name:, properties: [])
      Class.new(Chronicle::Schema::Validation::BaseContract) do
        type class_name

        params(Chronicle::Schema::Validation::ContractFactory.create_schema(class_name:, properties:))

        properties.each do |property|
          edge_name = property[:name_snake_case].to_sym

          if %i[zero_or_more one_or_more].include?(property[:cardinality])
            rule(edge_name).each do |index:|
              errors = edge_validator.validate(class_name, edge_name, value)
              # puts "result of edge_validation for #{edge_name}: #{res}"
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
              errors = edge_validator.validate(class_name, edge_name, value)
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

    def self.create_schema(class_name:, properties: [])
      Dry::Schema.JSON do
        required(:@type).value(:str?).filled(eql?: class_name)

        properties.each do |property|
          property_name = property[:name_snake_case].to_sym
          type = Chronicle::Schema::Validation::ContractFactory.build_type(property[:range_with_subclasses])

          outer_macro = %i[zero_or_one zero_or_more].include?(property[:cardinality]) ? :optional : :required
          inner_type = if %i[zero_or_more one_or_more].include?(property[:cardinality])
                         Chronicle::Schema::Types::Array.of(type)
                       else
                         type
                       end

          send(outer_macro, property_name).filled(inner_type)
        end
      end
    end

    def self.build_type(range)
      literals = []
      literals << Chronicle::Schema::Types::Nominal::Integer if range.include?('https://schema.chronicle.app/Integer')
      literals << Chronicle::Schema::Types::Nominal::Float if range.include?('https://schema.chronicle.app/Float')
      literals << Chronicle::Schema::Types::Nominal::String if range.include?('https://schema.chronicle.app/Text')
      literals << Chronicle::Schema::Types::JSON::Time if range.include?('https://schema.chronicle.app/DateTime')
  
      type = Chronicle::Schema::Types.edge_plus_literal(literals)
    end
  end
end
