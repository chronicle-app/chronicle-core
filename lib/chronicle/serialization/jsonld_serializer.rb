module Chronicle::Serialization
  class JSONLDSerializer < Chronicle::Serialization::Serializer
    DEFAULT_CONTEXT = 'https://schema.chronicle.app/'

    def serializable_hash
      {
        '@context': DEFAULT_CONTEXT
      }.merge(serialize_record(@record))
    end

    private

    def serialize_record(record)
      properties = record.properties.to_h.compact.transform_values do |value|
        if value.is_a?(Array)
          value.map { |v| serialize_value(v) }
        else
          serialize_value(value)
        end
      end

      {
        '@type': record.type.to_s,
        '@id': record.id
      }.merge(properties).compact
    end

    def serialize_value(value)
      if value.is_a?(Chronicle::Serialization::Record)
        serialize_record(value)
      else
        value
      end
    end
  end
end
