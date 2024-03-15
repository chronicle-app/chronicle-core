module Chronicle::Models
  class ModelFactory
    def initialize(properties: [], superclasses: [])
      @properties = properties
      @superclasses = superclasses
    end

    def generate
      attribute_info = @properties.map do |property|
        generate_attribute_info(property)
      end

      superclasses = @superclasses

      Class.new(Chronicle::Models::Base) do
        set_superclasses(superclasses)
        attribute_info.each do |a|
          attribute(a[:name], a[:type])
        end
      end
    end

    private

    def generate_attribute_info(property)
      range = build_type(property)
      type = if property.many?
               Chronicle::Schema::Types::Array.of(range)
             else
               range
             end

      type = type.optional.default(nil) unless property.required?
      type = type.meta(required: property.required?, many: property.many?)

      {
        name: property.id_snakecase.to_sym,
        type:
      }
    end

    def build_type(property)
      type_values = []

      range = property.range_identifiers

      type_values << Chronicle::Schema::Types::Params::Time if range.include? :DateTime
      type_values << Chronicle::Schema::Types::String if %i[Text URL].intersect?(range)
      # type_values << Chronicle::Schema::Types::String if true
      type_values << Chronicle::Schema::Types::Params::Integer if range.include? :Integer
      type_values << Chronicle::Models.schema_type(range)

      # type_values = type_values.map do |type|
      #   type.meta(required: property.required?, many: property.many?)
      # end

      union = type_values.reduce do |memo, type|
        memo | type
      end
    end
  end
end
