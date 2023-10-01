require 'dry/schema' # TODO: Lazy load this
Dry::Schema.load_extensions(:hints)
Dry::Schema.load_extensions(:info)

# require 'chronicle/serialization'
# require 'chronicle/schema/types/entities'
# require 'chronicle/schema/types/activities'

module Chronicle::Schema
  class Validator
    # EntityIdentifiableAttributes = Dry::Schema.Params do
    #   required(:provider).filled(:string)
    # end

    # EntityIdentifiableSchema = Dry::Schema.Params do
    #   required(:provider).filled(:string)
    # end

    # ActorEntitySchema = Dry::Schema.Params do
    #   required(:represents).filled(:string, eql?: 'identity')
    # end

    # MusicArtistEntitySchema = Dry::Schema.Params do
    #   required(:represents).filled(:string, eql?: 'music_artist')
    # end

    # MusicRecordingEntitySchema = Dry::Schema.Params do
    #   required(:represents).filled(:string, eql?: 'music_recording')
    #   optional(:relationships).schema do
    #     optional(:album).hash do
    #       required(:data).hash(EntitySchema)
    #     end
    #     optional(:artists).hash do
    #       required(:data).array(:array).each do
    #         hash(MusicArtistEntitySchema)
    #       end
    #     end
    #   end
    # end

    # ActivitySchema = Dry::Schema.Params do
    #   required(:type).filled(:string, eql?: 'activities')
    #   required(:attributes).schema do
    #     required(:verb).filled(:string)
    #     optional(:start_at).maybe(:time) # Adjust type as needed
    #     optional(:end_at).maybe(:time)   # Adjust type as needed
    #   end
    #   required(:relationships).schema do
    #     optional(:involved).hash do
    #       required(:data).hash(EntitySchema)
    #     end
    #     required(:actor).hash do
    #       required(:data).hash(EntitySchema) do
    #         required(:attributes).schema(EntityIdentifiableSchema & ActorEntitySchema)
    #       end
    #     end
    #   end
    #   required(:meta).schema(DedupeOnSchema)
    # end

    def self.validate_jsonapi(jsonapi)
      case jsonapi[:type]
      when 'entities'
        result = Chronicle::Schema::Types::Entities::EntitySchema.call(jsonapi)
      when 'activities'
        result = Chronicle::Schema::Types::Activities::ActivitySchema.call(jsonapi)
      else
        raise ArgumentError, "Unsupported type: #{jsonapi[:type]}"
      end

      if result.success?
        { success: true, data: result.to_h }
      else
        { success: false, errors: result.errors.to_h, hints: result.hints.to_h }
      end
    end

    def self.validate(record)
      serialized = Chronicle::Serialization::JSONAPISerializer.serialize(record)
      validate_jsonapi(serialized)
    end
  end
end
