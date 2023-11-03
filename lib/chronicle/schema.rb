module Chronicle
  module Schema
    class Error < StandardError; end
    class ValidationError < Error; end
  end
end

# require_relative "schema/validator"

require_relative 'schema/data/data'
require_relative 'schema/types'
require_relative 'schema/validation'
