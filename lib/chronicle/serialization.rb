require "chronicle/schema"

module Chronicle
  module Serialization
    class Error < StandardError; end

    class SerializationError < Error; end
  end
end

require_relative "serialization/serializer"
require_relative "serialization/hash_serializer"
require_relative "serialization/jsonapi_serializer"
require_relative "serialization/jsonld_serializer"
