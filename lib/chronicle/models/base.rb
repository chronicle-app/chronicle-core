require 'dry-struct'
require 'chronicle/schema/types'

module Chronicle::Models
  # The base class for all generated models
  class Base < Dry::Struct
    transform_keys(&:to_sym)
    schema schema.strict

    alias properties attributes

    # TODO: rename naked `provider` attribute
    CHRONICLE_ATTRIBUTES = %i[id].freeze
    # CHRONICLE_ATTRIBUTES = %i[id provider provider_id provider_slug provider_namespace].freeze

    CHRONICLE_ATTRIBUTES.each do |attribute|
      attribute(attribute, Chronicle::Schema::Types::String.optional.default(nil).meta(many: false, required: false))
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

    def meta
      {}
    end

    def to_h_flattened
      require 'chronicle/utils/hash_utils'
      Chronicle::Utils::HashUtils.flatten_hash(to_h)
    end

    # FIXME: this isn't working
    def self.many_cardinality_attributes
      schema.type.select do |type|
        type.meta[:many]
      end.map(&:name)
    end

    def self.one_cardinality_attributes
      schema.type.map(&:name) - many_cardinality_attributes
    end
  end

  def self.schema_type(types)
    Chronicle::Schema::Types::Instance(Chronicle::Models::Base).constructor do |input|
      unless input.class.type_id && [types].flatten.include?(input.class.type_id)
        raise Dry::Types::ConstraintError.new(:type?, input)
      end

      input
    end
  end
end
