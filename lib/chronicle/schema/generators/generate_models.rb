require 'erb'
require_relative '../base'
require_relative 'generator'

module Chronicle::Schema::Generators
  # Take a parsed schema and generate models as a string
  class GenerateModels < Chronicle::Schema::Generators::Generator
    MODEL_FILE = <<~MODEL_FILE
      # Automatically generated
      module <%= @namespace %>
      <% models.each do |model| -%>
      <%= with_indent(model.to_s, 1) %>
      <% end %>
      end
    MODEL_FILE

    MODEL_TEMPLATE = <<~MODEL_TEMPLATE
      class <%= class_name %> < Chronicle::Schema::Base
      <% attributes.each do |attribute| -%>
      <%= with_indent(attribute.to_s, 1) %>
      <% end -%>
      end

    MODEL_TEMPLATE

    def generate
      models = @parsed_schema.classes.map do |_class_name, class_details|
        next unless class_details

        generate_model(class_details[:name_short], class_details[:properties])
      end

      ERB.new(MODEL_FILE, trim_mode: '-').result(binding)
    end

    private

    def generate_model(class_name, properties = [])
      attributes = properties.map do |property|
        generate_attribute(property)
      end

      ERB.new(MODEL_TEMPLATE, trim_mode: '-').result(binding)
    end

    def generate_attribute(property)
      attribute_name = property[:name_snake_case]
      optional_modifier = '.optional.default(nil)' if %i[zero_or_more zero_or_one].include?(property[:cardinality])
      cardinality_meta = ".meta(cardinality: :#{property[:cardinality]})"

      range_str = property[:range_with_subclasses].map do |range|
        range_to_type(range)
      end.flatten.join(' | ')

      outer_type = if %i[one_or_more zero_or_more].include?(property[:cardinality])
                     "Chronicle::Schema::Types::Array.of(#{range_str})"
                   else
                     "(#{range_str})"
                   end

      "attribute :#{attribute_name}, #{outer_type}#{optional_modifier}#{cardinality_meta}"
    end

    def range_to_type(range)
      type = range.gsub('https://schema.chronicle.app/', "#{@namespace}::")
      output = ["Chronicle::Schema::Types.Instance(#{type})"]

      output << 'Chronicle::Schema::Types::String' if type == "#{@namespace}::Text"

      output
    end
  end
end
