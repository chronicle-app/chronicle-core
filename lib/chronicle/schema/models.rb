# Automatically generated
module Chronicle::Schema
  class DataType < Chronicle::Schema::Base
  end
  class Text < Chronicle::Schema::Base
  end
  class Number < Chronicle::Schema::Base
  end
  class DateTime < Chronicle::Schema::Base
  end
  class Entity < Chronicle::Schema::Base
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:URL])).optional.default(nil).meta(required: :false, many: :false)
  end
  class URL < Chronicle::Schema::Base
  end
  class CreativeWork < Chronicle::Schema::Base
  attribute :video, Chronicle::Schema::Types::Array.of(Chronicle::Schema.schema_type([:VideoObject])).optional.default(nil).meta(required: :false, many: :true)
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:URL])).optional.default(nil).meta(required: :false, many: :false)
  end
  class MusicGroup < Chronicle::Schema::Base
  attribute :video, Chronicle::Schema::Types::Array.of(Chronicle::Schema.schema_type([:VideoObject])).optional.default(nil).meta(required: :false, many: :true)
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:URL])).optional.default(nil).meta(required: :false, many: :false)
  end
  class Person < Chronicle::Schema::Base
  attribute :age, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :video, Chronicle::Schema::Types::Array.of(Chronicle::Schema.schema_type([:VideoObject])).optional.default(nil).meta(required: :false, many: :true)
  attribute :hair_length, (Chronicle::Schema.schema_type([:Number])).optional.default(nil).meta(required: :false, many: :false)
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:URL])).optional.default(nil).meta(required: :false, many: :false)
  end
  class MusicAlbum < Chronicle::Schema::Base
  attribute :by_artist, Chronicle::Schema::Types::Array.of(Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:MusicGroup, :Person, :Text, :URL])).optional.default(nil).meta(required: :false, many: :true)
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:URL])).optional.default(nil).meta(required: :false, many: :false)
  end
  class Activity < Chronicle::Schema::Base
  attribute :actor, (Chronicle::Schema.schema_type([:Person])).optional.default(nil).meta(required: :false, many: :false)
  attribute :verb, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).meta(required: :true, many: :false)
  attribute :object, (Chronicle::Schema.schema_type([:Entity, :CreativeWork, :MusicRecording, :VideoObject, :Person, :MusicAlbum, :Organization, :MusicGroup])).optional.default(nil).meta(required: :false, many: :false)
  attribute :end_at, (Chronicle::Schema::Types::Params::Time | Chronicle::Schema.schema_type([:DateTime])).optional.default(nil).meta(required: :false, many: :false)
  end
  class MusicRecording < Chronicle::Schema::Base
  attribute :by_artist, Chronicle::Schema::Types::Array.of(Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:MusicGroup, :Person, :Text, :URL])).optional.default(nil).meta(required: :false, many: :true)
  attribute :in_album, Chronicle::Schema::Types::Array.of(Chronicle::Schema.schema_type([:MusicAlbum])).optional.default(nil).meta(required: :false, many: :true)
  attribute :video, Chronicle::Schema::Types::Array.of(Chronicle::Schema.schema_type([:VideoObject])).optional.default(nil).meta(required: :false, many: :true)
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:URL])).optional.default(nil).meta(required: :false, many: :false)
  end
  class Organization < Chronicle::Schema::Base
  attribute :video, Chronicle::Schema::Types::Array.of(Chronicle::Schema.schema_type([:VideoObject])).optional.default(nil).meta(required: :false, many: :true)
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:URL])).optional.default(nil).meta(required: :false, many: :false)
  end
  class VideoObject < Chronicle::Schema::Base
  attribute :video, Chronicle::Schema::Types::Array.of(Chronicle::Schema.schema_type([:VideoObject])).optional.default(nil).meta(required: :false, many: :true)
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:Text, :URL])).optional.default(nil).meta(required: :false, many: :false)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([:URL])).optional.default(nil).meta(required: :false, many: :false)
  end

end
