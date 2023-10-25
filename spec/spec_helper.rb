require 'simplecov'
SimpleCov.start

require 'support/matchers/valid_contract_matcher'

require "bundler/setup"

require "chronicle/core"
require "chronicle/schema"
require "chronicle/serialization"

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.mock_with :rspec

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
