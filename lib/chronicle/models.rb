require_relative 'models/generation'
require_relative 'models/base'
require_relative 'models/builder'

module Chronicle
  module Models
    class Error < StandardError; end
    class AttributeError < Error; end

    # Automatically generate models from the default schema
    # We will do this dynamically whenever 'chronicle/models' is required
    # until the performance becomes an issue (currently takes about ~10ms)
    include Chronicle::Models::Generation

    extend Chronicle::Models::Builder
  end
end
