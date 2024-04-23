module Chronicle
  module Schema
    module Validation
      # FIXME:
      # - refactor all of this
      # - handle different serialization flavours
      # - move to model of memoizing individual contracts and generating them on demand
      @contracts = {}
      @graph = nil

      class << self
        attr_accessor :graph, :contracts
      end

      def self.unload_contracts
        @contracts = {}
      end

      def self.set_contract(name, contract)
        @contracts[name] = contract
      end

      def self.get_contract(name)
        # FIXME:
        # Chronicle::Schema::Validation::Generation.generate_contracts

        @contracts[name]
      end

      def self.contracts_generated?
        !@contracts_generated.nil?
      end
    end
  end
end

require_relative 'validation/generation'
require_relative 'validation/validator'
require_relative 'validation/edge_validator'
require_relative 'validation/base_contract'
require_relative 'validation/contract_factory'
