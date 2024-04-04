module Chronicle::Serialization
  class Serializer
    # Construct a new instance of this serializer.
    # == Parameters:
    # options::
    #   Options for configuring this Serializers
    def initialize(record, options = {})
      unless record.is_a?(Chronicle::Serialization::Record)
        raise(ArgumentError,
          "Must be a Record. It is a: #{record.class}")
      end

      @record = record
      @options = options
    end

    # Serialize a record as a hash
    def serializable_hash
      raise NotImplementedError
    end

    def self.serialize(data)
      record = if data.is_a?(Chronicle::Models::Base)
                 Chronicle::Serialization::Record.build_from_model(data)
               elsif data.is_a?(Chronicle::Serialization::Record)
                 data
               else
                 raise ArgumentError, 'data must be a Chronicle::Models::Base or Chronicle::Serialization::Record'
               end

      serializer = new(record)
      serializer.serializable_hash
    end
  end
end
