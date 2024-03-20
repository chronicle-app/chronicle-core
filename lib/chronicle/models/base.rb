require 'dry-struct'
require 'chronicle/schema/types'

module Chronicle::Models
  # The base class for all generated models
  class Base < Dry::Struct
    transform_keys(&:to_sym)
    schema schema.strict

    def properties
      # FIXME: think about this more. Does dedupe belong in serialization
      attributes.except(:dedupe_on)
    end

    attribute(:id, Chronicle::Schema::Types::String.optional.default(nil).meta(many: false, required: false))

    # set of properties to dedupe on
    # each set of properties is an array of symbols representing the properties to dedupe on
    # example: [[:slug, :source], [:url]]
    attribute(:dedupe_on,
      Chronicle::Schema::Types::Array.of(Chronicle::Schema::Types::Array.of(Chronicle::Schema::Types::Symbol)).optional.default([]).meta(
        many: false, required: false
      ))

    def self.new(attributes = {})
      if block_given?
        attribute_struct = Struct.new(*schema.map(&:name)).new
        attribute_struct.dedupe_on = []

        yield(attribute_struct)
        attributes = attribute_struct.to_h
      end

      super(attributes)
    rescue Dry::Struct::Error, NoMethodError => e
      # TODO: be more clear about the attribute that's invalid
      raise AttributeError, e.message
    end

    def meta
      output = {}
      output[:dedupe_on] = dedupe_on unless dedupe_on.empty?
      output
    end

    def type_id
      self.class.type_id
    end

    # TODO: exclude dedupe_on from serialization
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
      unless input.type_id && [types].flatten.include?(input.type_id)
        raise Dry::Types::ConstraintError.new(:type?, input)
      end

      input
    end
  end
end
