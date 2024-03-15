module Chronicle::Schema::Validation
  class EdgeValidator
    def validate(type, edge, value)
      errors = {}
      return errors unless value.is_a?(Hash)

      value_type = (value[:@type] || value['@type']).to_sym

      property = fetch_property(type, edge)
      unless property
        errors[:base] = 'not a valid edge'
        return errors
      end

      complete_range = fetch_complete_range(property)

      unless complete_range.include?(value_type)
        errors[:base] = "#{value_type} is not a valid type for #{edge}. Valid types are #{complete_range.join(', ')}"
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

    def fetch_property(type, edge)
      klass = Chronicle::Schema::Validation::Generation.graph.find_class(type)
      klass&.all_properties&.find { |p| edge == p.id_snakecase }
    end

    def fetch_complete_range(property)
      property.range.each_with_object([]) do |range, memo|
        range_klass = Chronicle::Schema::Validation::Generation.graph.find_class_by_id(range)
        memo << range_klass.short_id
        memo.concat(range_klass.descendants.map(&:short_id))
      end.uniq.map(&:to_sym)
    end
  end
end
