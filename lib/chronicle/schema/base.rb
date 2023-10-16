require 'dry-struct'

module Chronicle::Schema
  module Types
    include Dry.Types()
  end

  class Base < Dry::Struct
    transform_keys(&:to_sym)
    schema schema.strict

    attribute :id, Types::String.optional.default(nil).meta(cardinality: :zero_or_one)

    alias properties attributes

    def meta
      {}
    end

    def self.new(attributes = {})
      if block_given?
        attribute_struct = Struct.new(*schema.map(&:name))
        attribute_struct = attribute_struct.new
        yield(attribute_struct)
        attributes = attribute_struct.to_h
      end

      super(attributes)
    rescue Dry::Struct::Error, NoMethodError => e
      # TODO: be more clear about the attribute that's invalid
      raise AttributeError, e.message
    end

    def self.one_cardinality_attributes
      schema.type.filter do |type|
        [:one, :zero_or_one].include?(type.meta[:cardinality])
      end.map(&:name)
    end

    def self.many_cardinality_attributes
      schema.type.map(&:name) - one_cardinality_attributes
    end
  end
end
