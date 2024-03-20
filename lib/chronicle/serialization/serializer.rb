module Chronicle::Serialization
  class Serializer
    # Construct a new instance of this serializer.
    # == Parameters:
    # options::
    #   Options for configuring this Serializers
    def initialize(record, options = {})
      unless record.is_a?(Chronicle::Models::Base)
        raise(SerializationError,
          "Record must be a subtype of Chronicle::Models::Base. It is a: #{record.class}")
      end

      @record = record
      @options = options
    end

    # Serialize a record as a hash
    def serializable_hash
      raise NotImplementedError
    end

    def self.serialize(record)
      serializer = new(record)
      serializer.serializable_hash
    end
  end
end
