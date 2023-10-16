module Chronicle
  module Schema
    class Error < StandardError; end

    class AttributeError < Error; end
  end
end

# require_relative "schema/validator"

require_relative 'schema/base'
require_relative 'schema/models'
require_relative 'schema/validator'
