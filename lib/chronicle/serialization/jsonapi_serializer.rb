module Chronicle::Serialization
  class JSONAPISerializer < Chronicle::Serialization::Serializer
    def serializable_hash
      { data: serialize_record(@record) }
    end

    private

    def serialize_record(record)
      identifier_hash(record).merge({
        attributes: attribute_hash(record),
        relationships: associations_hash(record),
        meta: record.meta
      })
    end

    def identifier_hash(record)
      {
        type: record.type.to_s,
        id: record.id
      }.compact
    end

    def attribute_hash(record)
      record.attribute_properties.compact.transform_values do |v|
        if v.is_a?(Chronicle::Serialization::Record)
          serialize_record(v)
        else
          v
        end
      end
    end

    def associations_hash(record)
      record.association_properties.compact.to_h do |k, v|
        if v.is_a?(Array)
          [k, { data: v.map { |record| serialize_record(record) } }]
        elsif v.is_a?(Chronicle::Serialization::Record)
          [k, { data: serialize_record(v) }]
        else
          # [k, { data: v }]
          [k, v]
        end
      end
    end
  end
end
