require 'dry-struct'

module Chronicle::Schema
  class Base < Dry::Struct
    transform_keys(&:to_sym)
    schema schema.strict

    alias properties attributes

    # TODO: rename naked `provider` attribute
    CHRONICLE_ATTRIBUTES = %i[id provider provider_id provider_slug provider_namespace].freeze

    CHRONICLE_ATTRIBUTES.each do |attribute|
      attribute(attribute, Types::String.optional.default(nil).meta(cardinality: :zero_or_one))
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

    def type
      self.class.name.split('::').last
    end

    def meta
      {}
    end

    def to_h_flattened
      require 'chronicle/utils/hash_utils'
      Chronicle::Utils::HashUtils.flatten_hash(to_h)
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

  def self.schema_type(types)
    Types::Instance(Chronicle::Schema::Base).constructor do |input|
      unless input.respond_to?(:type) && [types].flatten.include?(input.type)
        raise Dry::Types::ConstraintError.new(:type?, input)
      end
      input
    end
  end

  # SchemaType = proc do |types|
  #   Types::Instance(Chronicle::Schema::Base).constructor do |input|
  #     unless input.respond_to?(:type) && [types].flatten.include?(input.type)
  #       raise Dry::Types::ConstraintError.new(:type?, input)
  #     end
  #     input
  #   end
  # end
end
