# Automatically generated

require 'dry/schema'
Dry::Schema.load_extensions(:hints)
Dry::Schema.load_extensions(:info)

module Chronicle::Schema


  DataTypeSchema = Dry::Schema.Params do
  required(:"@type").value(eql?: 'DataType')
  end

  TextSchema = Dry::Schema.Params do
  required(:"@type").value(eql?: 'Text')
  end

  EntitySchema = Dry::Schema.Params do
  required(:"@type").value(eql?: 'Entity')
  optional(:name){ str? | hash(Chronicle::Schema::TextSchema) }
  optional(:description){ str? | hash(Chronicle::Schema::TextSchema) }
  end

  PersonSchema = Dry::Schema.Params do
  required(:"@type").value(eql?: 'Person')
  optional(:age){ str? | hash(Chronicle::Schema::TextSchema) }
  optional(:name){ str? | hash(Chronicle::Schema::TextSchema) }
  optional(:description){ str? | hash(Chronicle::Schema::TextSchema) }
  end

  MusicGroupSchema = Dry::Schema.Params do
  required(:"@type").value(eql?: 'MusicGroup')
  optional(:age){ str? | hash(Chronicle::Schema::TextSchema) }
  optional(:name){ str? | hash(Chronicle::Schema::TextSchema) }
  optional(:description){ str? | hash(Chronicle::Schema::TextSchema) }
  end

  MusicAlbumSchema = Dry::Schema.Params do
  required(:"@type").value(eql?: 'MusicAlbum')
  optional(:by_artist) do
  str? | array? & each do
  hash(Chronicle::Schema::MusicGroupSchema) | hash(Chronicle::Schema::PersonSchema) | str? | hash(Chronicle::Schema::TextSchema)
  end
  end
  optional(:name){ str? | hash(Chronicle::Schema::TextSchema) }
  optional(:description){ str? | hash(Chronicle::Schema::TextSchema) }
  end

  ActivitySchema = Dry::Schema.Params do
  required(:"@type").value(eql?: 'Activity')
  optional(:actor){ hash(Chronicle::Schema::PersonSchema) | hash(Chronicle::Schema::MusicGroupSchema) }
  required(:verb){ str? | hash(Chronicle::Schema::TextSchema) }
  optional(:object){ hash(Chronicle::Schema::EntitySchema) | hash(Chronicle::Schema::PersonSchema) | hash(Chronicle::Schema::MusicGroupSchema) | hash(Chronicle::Schema::MusicAlbumSchema) }
  end


end
