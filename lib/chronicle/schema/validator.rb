require 'dry/schema' # TODO: Lazy load this
Dry::Schema.load_extensions(:hints)
Dry::Schema.load_extensions(:info)

module Chronicle::Schema
  class Validator
    EntitySchema = Dry::Schema.Params do
      required(:type).filled(:string, eql?: 'entities')
      required(:attributes).type(:hash)
    end

    EntityIdentifiableSchema = Dry::Schema.Params do
      required(:provider).filled(:string)
    end

    ActorEntitySchema = Dry::Schema.Params do
      required(:represents).filled(:string, eql?: 'identity')
    end

    ActivitySchema = Dry::Schema.Params do
      required(:type).filled(:string, eql?: 'activities')
      required(:attributes).schema do
        required(:verb).filled(:string)
        optional(:start_at).maybe(:string) # Adjust type as needed
        optional(:end_at).maybe(:string)   # Adjust type as needed
      end
      required(:relationships).schema do
        required(:actor).hash do
          required(:data).hash(EntitySchema) do
            required(:attributes).schema(EntityIdentifiableSchema & ActorEntitySchema)
          end
        end
      end
    end

    def self.validate(input)
      case input
      when Entity
        result = EntitySchema.call(input.to_h_jsonapi)
      when Activity
        result = ActivitySchema.call(input.to_h_jsonapi)
      else
        raise ArgumentError, "Unsupported type: #{input.class}"
      end

      if result.success?
        { success: true, data: result.to_h }
      else
        { success: false, errors: result.errors.to_h, hints: result.hints.to_h }
      end
    end
  end
end
