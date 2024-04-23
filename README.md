# Chronicle::Core

Home of some shared code for [Chronicle](https://github.com/chronicle-app/). 

## Schema

Chronicle Schema is a set of types and properties that are used to describe personal digital history. The schema is a derivative of [Schema.org](https://schema.org). For the most part, it is a subset of Schema.org types and properties. 

There are a few top-level properties that are unique to Chronicle:
- `source` - the source of the record (e.g. `spotify`, `twitter`, `instagram`)
- `sourceId` - the unique identifier of the record in the source system
- `slug` - a human-readable identifier for the record (e.g. `bridge-over-troubled-water`)

To view all valid types and properties in Chronicle Schema, see the `schema/` diretory.

TODO: generate doc files from schema automatically.

To update the schema, edit `schema/chronicle_schema_VERSION.rb` and run `rake schema:generate`.

## Models

For each valid type in Chronicle Schema, there is a corresponding model class that can instantiated as an immutable Ruby object.

### Usage

```ruby
require 'chronicle/models'

song = Chronicle::Models::MusicRecording.new do |r|
  r.name = 'Bridge Over Troubled Water'
  r.in_album = 'Aretha Live at Fillmore West'
  r.by_artist = [Chronicle::Models::MusicGroup.new(name: 'Aretha Franklin')]
  r.duration = "PT5M49S"
  r.source = 'spotify'
  r.source_id = '0e0isrwFsu5W0KJqxkfPpX?si=3d2f08d6d63149bb'
end

puts song.to_json
# => {"@type":"MusicRecording","name":"Bridge Over Troubled Water","in_album":"Aretha Live at Fillmore West","by_artist":[{"@type":"MusicGroup","name":"Aretha Franklin"}],"duration":"PT5M49S","source":"spotify","sourceId":"0e0isrwFsu5W0KJqxkfPpX?si=3d2f08d6d63149bb"}
```

## Validation

chronicle-core provides a validator that checks if a given JSON object conforms to the Chronicle Schema. The validator assumes the JSON is serialized as JSON-LD.

### Usage

```ruby
# TODO
```

## Serialization

chronicle-core provides the following serializers for records:
- JSON
- JSONAPI
- JSON-LD

## Development

To run the tests:

```bash
# Run once
bundle exec rspec

# Run continuously
bundle exec guard
```

## Get in touch

- [@hyfen](https://twitter.com/hyfen) on Twitter
- [@hyfen](https://github.com/hyfen) on Github
- Email: andrew@hyfen.net

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/chronicle-app/chronicle-core. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Chronicle::ETL project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/chronicle-app/chronicle-core/blob/main/CODE_OF_CONDUCT.md).

