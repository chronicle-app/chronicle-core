module Chronicle::Serialization
  class JSONAPISerializer < Chronicle::Serialization::Serializer
    def serializable_hash
      identifier_hash.merge({
        attributes: attribute_hash,
        relationships: associations_hash,
        meta: @record.meta
      })
    end

    private

    def identifier_hash
      {
        type: @record.class.name.split('::').last,
        id: @record.id
      }.compact
    end

    def attribute_hash
      @record.attributes.slice(*@record.class.one_cardinality_attributes).compact.transform_values do |v|
        if v.is_a?(Chronicle::Models::Base)
          JSONAPISerializer.new(v).serializable_hash
        else
          v
        end
      end
    end

    def associations_hash
      assocations = @record.attributes.slice(*@record.class.many_cardinality_attributes).compact
      assocations.map do |k, v|
        if v.is_a?(Array)
          [k, { data: v.map { |record| JSONAPISerializer.new(record).serializable_hash } }]
        elsif v.is_a?(Chronicle::Models::Base)
          [k, { data: JSONAPISerializer.new(v).serializable_hash }]
        else
          # [k, { data: v }]
          [k, v]
        end
      end.to_h
    end
  end
end
