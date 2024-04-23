module Chronicle
  module Schema
    class Error < StandardError; end
    class ValidationError < Error; end
  end
end

# require_relative "schema/validator"

require_relative 'schema/types'
require_relative 'schema/validation'
require_relative 'schema/schema_property'
require_relative 'schema/schema_type'
require_relative 'schema/schema_graph'
