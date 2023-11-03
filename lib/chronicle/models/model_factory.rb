module Chronicle::Models
  class ModelFactory
    def initialize(properties = [])
      @properties = properties
    end

    def generate
      attribute_info = @properties.map do |property|
        generate_attribute_info(property)
      end

      Class.new(Chronicle::Models::Base) do
        attribute_info.each do |a|
          attribute(a[:name], a[:type])
        end
      end
    end

    private

    def generate_attribute_info(property)
      range = range_to_type(property[:range_with_subclasses])
      type = if property[:is_many]
               Chronicle::Schema::Types::Array.of(range)
             else
               range
             end

      type = type.optional.default(nil) unless property[:is_required]

      {
        name: property[:name_snake_case],
        type:
      }
    end

    def range_to_type(range)
      type_values = []

      type_values << Chronicle::Schema::Types::String if %i[Text URL].intersect?(range)
      type_values << Chronicle::Schema::Types::Params::Time if range.include? :DateTime
      type_values << Chronicle::Schema::Types::Params::Integer if range.include? :Integer
      type_values << Chronicle::Models.schema_type(range)

      type_values.reduce do |memo, type|
        memo | type
      end
    end
  end
end
