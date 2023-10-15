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
      super
    rescue Dry::Struct::Error => e
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
