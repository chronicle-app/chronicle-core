# Automatically generated
module Chronicle::Schema
  class DataType < Chronicle::Schema::Base
  end
  class Text < Chronicle::Schema::Base
  end
  class DateTime < Chronicle::Schema::Base
  end
  class Entity < Chronicle::Schema::Base
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  end
  class URL < Chronicle::Schema::Base
  end
  class CreativeWork < Chronicle::Schema::Base
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  end
  class MusicGroup < Chronicle::Schema::Base
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  end
  class Person < Chronicle::Schema::Base
  attribute :age, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  end
  class MusicAlbum < Chronicle::Schema::Base
  attribute :by_artist, Chronicle::Schema::Types::Array.of(Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["MusicGroup", "Person", "Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_more)
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  end
  class Activity < Chronicle::Schema::Base
  attribute :actor, (Chronicle::Schema.schema_type([["Person"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :verb, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).meta(cardinality: :one)
  attribute :object, (Chronicle::Schema.schema_type([["Entity", "CreativeWork", "MusicRecording", "Person", "MusicAlbum", "Organization", "MusicGroup"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :end_at, (Chronicle::Schema::Types::Params::Time | Chronicle::Schema.schema_type([["DateTime"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  end
  class MusicRecording < Chronicle::Schema::Base
  attribute :by_artist, Chronicle::Schema::Types::Array.of(Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["MusicGroup", "Person", "Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_more)
  attribute :in_album, Chronicle::Schema::Types::Array.of(Chronicle::Schema.schema_type([["MusicAlbum"]])).optional.default(nil).meta(cardinality: :zero_or_more)
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  end
  class Organization < Chronicle::Schema::Base
  attribute :name, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :description, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["Text", "URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :url, (Chronicle::Schema::Types::String | Chronicle::Schema.schema_type([["URL"]])).optional.default(nil).meta(cardinality: :zero_or_one)
  end

end
