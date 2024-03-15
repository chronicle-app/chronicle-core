module Chronicle::Serialization
  class HashSerializer < Chronicle::Serialization::Serializer
    def serializable_hash
      @record.properties.transform_values do |v|
        if v.is_a?(Array)
          v.map { |record| HashSerializer.new(record).serializable_hash }
        elsif v.is_a?(Chronicle::Models::Base)
          HashSerializer.new(v).serializable_hash
        else
          v
        end
      end.compact
    end
  end
end
