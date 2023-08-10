# frozen_string_literal: true

require_relative "core/version"

begin
  require 'pry'
rescue LoadError
  # Pry not available
end
