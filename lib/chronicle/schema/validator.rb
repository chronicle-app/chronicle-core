require 'dry/schema' # TODO: Lazy load this
module Chronicle::Schema
  class Validator
    Dry::Schema.load_extensions(:hints)
    Dry::Schema.load_extensions(:info)

    def self.validate(record)
    end
  end
end
