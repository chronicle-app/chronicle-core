require 'dry-types'

module Chronicle::Schema
  module Types
    include Dry.Types()

    ChronicleEntity = Hash.constructor do |value|
      type = value[:'@type']

      contract_klass = Chronicle::Schema::Validation.get_contract(type)
      raise Dry::Types::ConstraintError.new("Invalid type: #{type}") unless contract_klass

      result = contract_klass.schema.call(value)
      result.to_h
    end

    # ChronicleEdgeValue = Integer | String | ChronicleEntity

    def self.edge_plus_literal(literals)
      return ChronicleEntity unless literals.any?

      literals.reduce { |acc, literal| acc | literal } | ChronicleEntity
    end
  end
end
