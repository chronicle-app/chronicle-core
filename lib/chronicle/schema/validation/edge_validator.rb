module Chronicle::Schema::Validation
  class EdgeValidator
    def validate(type, edge, value)
      errors = {}
      # puts "validating #{edge} for #{type} with value #{value}"
      return errors unless value.is_a?(Hash)

      value_type = (value[:@type] || value['@type']).to_sym

      edge_details = get_edge_details(type, edge)
      unless edge_details
        errors[:base] = 'not a valid edge'
        return errors
      end

      valid_range_types = edge_details[:range_with_subclasses]

      unless valid_range_types.include?(value_type)
        errors[:base] = "not a valid type for #{edge}: #{value_type}"
        return errors
      end

      contract_klass = Chronicle::Schema::Validation.get_contract(value_type)
      unless contract_klass
        errors[:base] = "no contract found for #{value_type}"
        return errors
      end

      result = contract_klass.new.call(value)

      result.errors.to_h
    end

    private

    def get_edge_details(type, edge)
      class_details = Chronicle::Schema::Validation.class_data[type]
      return false unless class_details

      class_details[:properties].find do |property|
        property[:name_snake_case] == edge.to_sym
      end
    end
  end
end
