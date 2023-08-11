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
        type: @record.class::TYPE,
        id: @record.id
      }.compact
    end

    def attribute_hash
      @record.attributes.compact
    end

    def associations_hash
      @record.associations.map do |k, v|
        if v.is_a?(Array)
          [k, { data: v.map{|record| JSONAPISerializer.new(record).serializable_hash} }]
        else
          [k, { data: JSONAPISerializer.new(v).serializable_hash }]
        end
      end.to_h
    end
  end
end
