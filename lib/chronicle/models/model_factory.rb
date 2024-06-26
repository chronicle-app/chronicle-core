module Chronicle
  module Models
    class ModelFactory
      attr_reader :id

      def initialize(type_id:, properties: [])
        @type_id = type_id
        @properties = properties
      end

      def generate
        attribute_info = @properties.map do |property|
          generate_attribute_info(property)
        end

        type_id = @type_id

        Class.new(Chronicle::Models::Base) do
          attribute_info.each do |a|
            attribute(a[:name], a[:type])
          end

          @type_id = type_id
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

        full_range_identifiers = property.full_range_identifiers

        type_values << Chronicle::Schema::Types::Params::Time if full_range_identifiers.include? :DateTime
        type_values << Chronicle::Schema::Types::String if %i[Text URL Distance Duration Energy
                                                              Mass].intersect?(full_range_identifiers)

        type_values << Chronicle::Schema::Types::Params::Float if full_range_identifiers.include? :Float
        type_values << Chronicle::Schema::Types::Params::Integer if full_range_identifiers.include? :Integer
        type_values << Chronicle::Models.schema_type(full_range_identifiers)

        type_values.reduce do |memo, type|
          memo | type
        end
      end
    end
  end
end
