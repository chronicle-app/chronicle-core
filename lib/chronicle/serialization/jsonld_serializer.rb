module Chronicle::Serialization
  class JSONLDSerializer < Chronicle::Serialization::Serializer
    def serializable_hash
      properties = @record.properties.to_h.compact.transform_values do |value|
        if value.is_a?(Array)
          value.map { |v| serialize_value(v) }
        else
          serialize_value(value)
        end
      end
      {
        '@type': @record.type_id.to_s
      }.merge(properties)
    end

    private

    def serialize_value(value)
      if value.is_a?(Chronicle::Models::Base)
        JSONLDSerializer.new(value).serializable_hash
      else
        value
      end
    end
  end
end
