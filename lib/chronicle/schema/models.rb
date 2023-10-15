# Automatically generated
module Chronicle::Schema

  class DataType < Chronicle::Schema::Base
  end
  class Text < Chronicle::Schema::Base
  end
  class Entity < Chronicle::Schema::Base
  attribute :name, (Chronicle::Schema::Types.Instance(Chronicle::Schema::Text) | Chronicle::Schema::Types::String).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :description, (Chronicle::Schema::Types.Instance(Chronicle::Schema::Text) | Chronicle::Schema::Types::String).optional.default(nil).meta(cardinality: :zero_or_one)
  end
  class Person < Chronicle::Schema::Base
  attribute :age, (Chronicle::Schema::Types.Instance(Chronicle::Schema::Text) | Chronicle::Schema::Types::String).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :name, (Chronicle::Schema::Types.Instance(Chronicle::Schema::Text) | Chronicle::Schema::Types::String).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :description, (Chronicle::Schema::Types.Instance(Chronicle::Schema::Text) | Chronicle::Schema::Types::String).optional.default(nil).meta(cardinality: :zero_or_one)
  end
  class MusicGroup < Chronicle::Schema::Base
  attribute :age, (Chronicle::Schema::Types.Instance(Chronicle::Schema::Text) | Chronicle::Schema::Types::String).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :name, (Chronicle::Schema::Types.Instance(Chronicle::Schema::Text) | Chronicle::Schema::Types::String).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :description, (Chronicle::Schema::Types.Instance(Chronicle::Schema::Text) | Chronicle::Schema::Types::String).optional.default(nil).meta(cardinality: :zero_or_one)
  end
  class MusicAlbum < Chronicle::Schema::Base
  attribute :by_artist, Chronicle::Schema::Types::Array.of(Chronicle::Schema::Types.Instance(Chronicle::Schema::MusicGroup) | Chronicle::Schema::Types.Instance(Chronicle::Schema::Person) | Chronicle::Schema::Types.Instance(Chronicle::Schema::Text) | Chronicle::Schema::Types::String).optional.default(nil).meta(cardinality: :zero_or_more)
  attribute :name, (Chronicle::Schema::Types.Instance(Chronicle::Schema::Text) | Chronicle::Schema::Types::String).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :description, (Chronicle::Schema::Types.Instance(Chronicle::Schema::Text) | Chronicle::Schema::Types::String).optional.default(nil).meta(cardinality: :zero_or_one)
  end
  class Activity < Chronicle::Schema::Base
  attribute :actor, (Chronicle::Schema::Types.Instance(Chronicle::Schema::Person) | Chronicle::Schema::Types.Instance(Chronicle::Schema::MusicGroup)).optional.default(nil).meta(cardinality: :zero_or_one)
  attribute :verb, (Chronicle::Schema::Types.Instance(Chronicle::Schema::Text) | Chronicle::Schema::Types::String).meta(cardinality: :one)
  attribute :object, (Chronicle::Schema::Types.Instance(Chronicle::Schema::Entity) | Chronicle::Schema::Types.Instance(Chronicle::Schema::Person) | Chronicle::Schema::Types.Instance(Chronicle::Schema::MusicGroup) | Chronicle::Schema::Types.Instance(Chronicle::Schema::MusicAlbum)).optional.default(nil).meta(cardinality: :zero_or_one)
  end

end
