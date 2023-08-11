module Chronicle::Serialization
  class Serializer
    # Construct a new instance of this serializer.
    # == Parameters:
    # options::
    #   Options for configuring this Serializers
    def initialize(record, options = {})
      raise(SerializationError, "Record must be a subclass of Chronicle::Schema::Base") unless record.is_a?(Chronicle::Schema::Base)

      @record = record
      @options = options
    end

    # Serialize a record as a hash
    def serializable_hash
      raise NotImplementedError
    end

    def self.serialize(record)
      serializer = self.new(record)
      serializer.serializable_hash
    end
  end
end
