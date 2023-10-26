require 'dry-types'

module Chronicle::Schema
  module Types
    include Dry.Types()

    def self.coerce_chronicle_entity(value)
      type = value[:@type]

      contract_klass = Chronicle::Schema::Validation.get_contract(type)
      # TODO: maybe something smarter here?
      # return value unless contract_klass

      result = contract_klass.schema.call(value)
      result.success? ? result.to_h : value
    end

    CoercibleChronicleEdgeWrapper = Hash.constructor do |value|
      # puts "CoercibleChronicleEdgeWrapper: #{value}"
      # I dont understand why value can be an array but here we are
      # The only thing we care about here is getting the coercions from the 
      # nested schemas

      case value
      when ::Array
        coerced_array = value.map do |item|
          Chronicle::Schema::Types.coerce_chronicle_entity(item)
        end
        next coerced_array

      when ::Hash
        next Chronicle::Schema::Types.coerce_chronicle_entity(value)
      end
    end

    def self.edge_plus_literal(literals)
      return CoercibleChronicleEdgeWrapper unless literals.any?

      literals.reduce { |acc, literal| acc | literal } | CoercibleChronicleEdgeWrapper
    end
  end
end
