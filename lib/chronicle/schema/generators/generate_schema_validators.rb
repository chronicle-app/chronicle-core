require 'erb'
require_relative 'generator'

module Chronicle::Schema::Generators
  # Take a parsed schema and generate models as a string
  class GenerateSchemaValidators < Chronicle::Schema::Generators::Generator
    VALIDATOR_FILE = <<~VALIDATOR_FILE
      # Automatically generated

      require 'dry/schema'
      Dry::Schema.load_extensions(:hints)
      Dry::Schema.load_extensions(:info)

      module <%= @namespace %>
      <% schemas.each do |schema| -%>
      <%= with_indent(schema.to_s, 1) %>

      <% end %>
      end
    VALIDATOR_FILE

    SCHEMA_TEMPLATE = <<-SCHEMA_TEMPLATE
      <%=
      class_name %>Schema = Dry::Schema.Params do
        required(:"@type").value(eql?: '<%= class_name %>')
        <% rules.each do |rule| -%>
        <%= with_indent(rule.to_s, 2) %>
        <% end -%>
      end
    SCHEMA_TEMPLATE

    def generate
      schemas = @parsed_schema.classes.map do |class_name, class_details|
        next unless class_details

        generate_schemas(class_details[:name_short], class_details[:properties])
      end

      validators = []

      ERB.new(VALIDATOR_FILE, trim_mode: "-").result(binding)
    end

    private

    def generate_schemas(class_name, properties=[])
      rules = properties.map do |property|
        generate_rule(property)
      end

      attributes = []

      ERB.new(SCHEMA_TEMPLATE, trim_mode: "-").result(binding)
    end

    def generate_rule(property)
      name = property[:name_snake_case]

      range_str = property[:range_with_subclasses].map do |range|
        range_to_schema(range)
      end.flatten.join(' | ')

      case property[:cardinality]
      when :one
        "required(:#{name}){ #{range_str} }"
      when :zero_or_one
        "optional(:#{name}){ #{range_str} }"
      when :one_or_more
        <<~RULE
          required(:#{name}) do
            str? | array? & each do
              #{range_str}
            end
          end
        RULE
      when :zero_or_more
        <<~RULE
          optional(:#{name}) do
            str? | array? & each do
              #{range_str}
            end
          end
        RULE
      end
    end

    def range_to_schema(range)
      type = range.gsub('https://schema.chronicle.app/', "#{@namespace}::")
      output = []
      output << 'str?' if type == "#{@namespace}::Text"
      output << "hash(#{type}Schema)"
      output
    end
  end
end
