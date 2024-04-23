module Chronicle
  module Serialization
    class HashSerializer < Chronicle::Serialization::Serializer
      def serializable_hash
        @record.to_h
      end
    end
  end
end
