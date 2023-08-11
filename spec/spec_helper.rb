require 'simplecov'
SimpleCov.start

require "bundler/setup"

require "chronicle/core"
require "chronicle/schema"
require "chronicle/serialization"

RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.mock_with :rspec

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
