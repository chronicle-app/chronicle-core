require 'erb'

require_relative '../base'
require_relative 'generator'

module Chronicle::Schema::Generators
  class GenerateHash < Generator
    HASH_FILE = <<~EOF
      module <%= @namespace %>
        CLASS_DATA = <%= classes.inspect %>
      end
    EOF

    def generate
      classes = @parsed_schema.classes

      ERB.new(HASH_FILE, nil, '-').result(binding)
    end
  end
end
