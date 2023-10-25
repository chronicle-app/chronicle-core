module Chronicle::Schema

  CLASS_DATA = {"https://schema.chronicle.app/DataType"=>{:name=>"https://schema.chronicle.app/DataType", :name_short=>"DataType", :properties=>[], :subclasses=>[], :superclasses=>["http://www.w3.org/2000/01/rdf-schema#Class"], :dependencies=>["http://www.w3.org/2000/01/rdf-schema#Class"]}, "https://schema.chronicle.app/Text"=>{:name=>"https://schema.chronicle.app/Text", :name_short=>"Text", :properties=>[], :subclasses=>["https://schema.chronicle.app/URL"], :superclasses=>[], :dependencies=>[]}, "https://schema.chronicle.app/DateTime"=>{:name=>"https://schema.chronicle.app/DateTime", :name_short=>"DateTime", :properties=>[], :subclasses=>[], :superclasses=>[], :dependencies=>[]}, "https://schema.chronicle.app/Entity"=>{:name=>"https://schema.chronicle.app/Entity", :name_short=>"Entity", :properties=>[{:name=>"https://schema.chronicle.app/name", :name_shortened=>"name", :name_snake_case=>"name", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/description", :name_shortened=>"description", :name_snake_case=>"description", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/url", :name_shortened=>"url", :name_snake_case=>"url", :range=>["https://schema.chronicle.app/URL"], :range_with_subclasses=>["https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}], :subclasses=>["https://schema.chronicle.app/CreativeWork", "https://schema.chronicle.app/MusicRecording", "https://schema.chronicle.app/Person", "https://schema.chronicle.app/MusicAlbum", "https://schema.chronicle.app/Organization", "https://schema.chronicle.app/MusicGroup"], :superclasses=>[], :dependencies=>[]}, "https://schema.chronicle.app/URL"=>{:name=>"https://schema.chronicle.app/URL", :name_short=>"URL", :properties=>[], :subclasses=>[], :superclasses=>["https://schema.chronicle.app/Text"], :dependencies=>["https://schema.chronicle.app/Text"]}, "https://schema.chronicle.app/CreativeWork"=>{:name=>"https://schema.chronicle.app/CreativeWork", :name_short=>"CreativeWork", :properties=>[{:name=>"https://schema.chronicle.app/name", :name_shortened=>"name", :name_snake_case=>"name", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/description", :name_shortened=>"description", :name_snake_case=>"description", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/url", :name_shortened=>"url", :name_snake_case=>"url", :range=>["https://schema.chronicle.app/URL"], :range_with_subclasses=>["https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}], :subclasses=>["https://schema.chronicle.app/MusicRecording"], :superclasses=>["https://schema.chronicle.app/Entity"], :dependencies=>["https://schema.chronicle.app/Entity"]}, "https://schema.chronicle.app/MusicGroup"=>{:name=>"https://schema.chronicle.app/MusicGroup", :name_short=>"MusicGroup", :properties=>[{:name=>"https://schema.chronicle.app/name", :name_shortened=>"name", :name_snake_case=>"name", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/description", :name_shortened=>"description", :name_snake_case=>"description", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/url", :name_shortened=>"url", :name_snake_case=>"url", :range=>["https://schema.chronicle.app/URL"], :range_with_subclasses=>["https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}], :subclasses=>[], :superclasses=>["https://schema.chronicle.app/Organization", "https://schema.chronicle.app/Entity"], :dependencies=>["https://schema.chronicle.app/Organization", "https://schema.chronicle.app/Entity"]}, "https://schema.chronicle.app/Person"=>{:name=>"https://schema.chronicle.app/Person", :name_short=>"Person", :properties=>[{:name=>"https://schema.chronicle.app/age", :name_shortened=>"age", :name_snake_case=>"age", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Person"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/name", :name_shortened=>"name", :name_snake_case=>"name", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/description", :name_shortened=>"description", :name_snake_case=>"description", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/url", :name_shortened=>"url", :name_snake_case=>"url", :range=>["https://schema.chronicle.app/URL"], :range_with_subclasses=>["https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}], :subclasses=>[], :superclasses=>["https://schema.chronicle.app/Entity"], :dependencies=>["https://schema.chronicle.app/Entity"]}, "https://schema.chronicle.app/MusicAlbum"=>{:name=>"https://schema.chronicle.app/MusicAlbum", :name_short=>"MusicAlbum", :properties=>[{:name=>"https://schema.chronicle.app/byArtist", :name_shortened=>"byArtist", :name_snake_case=>"by_artist", :range=>["https://schema.chronicle.app/MusicGroup", "https://schema.chronicle.app/Person", "https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/MusicGroup", "https://schema.chronicle.app/Person", "https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/MusicAlbum", "https://schema.chronicle.app/MusicRecording"], :cardinality=>:zero_or_more}, {:name=>"https://schema.chronicle.app/name", :name_shortened=>"name", :name_snake_case=>"name", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/description", :name_shortened=>"description", :name_snake_case=>"description", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/url", :name_shortened=>"url", :name_snake_case=>"url", :range=>["https://schema.chronicle.app/URL"], :range_with_subclasses=>["https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}], :subclasses=>[], :superclasses=>["https://schema.chronicle.app/Entity"], :dependencies=>["https://schema.chronicle.app/Entity"]}, "https://schema.chronicle.app/Activity"=>{:name=>"https://schema.chronicle.app/Activity", :name_short=>"Activity", :properties=>[{:name=>"https://schema.chronicle.app/actor", :name_shortened=>"actor", :name_snake_case=>"actor", :range=>["https://schema.chronicle.app/Person"], :range_with_subclasses=>["https://schema.chronicle.app/Person"], :domain=>["https://schema.chronicle.app/Activity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/verb", :name_shortened=>"verb", :name_snake_case=>"verb", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Activity"], :cardinality=>:one}, {:name=>"https://schema.chronicle.app/object", :name_shortened=>"object", :name_snake_case=>"object", :range=>["https://schema.chronicle.app/Entity"], :range_with_subclasses=>["https://schema.chronicle.app/Entity", "https://schema.chronicle.app/CreativeWork", "https://schema.chronicle.app/MusicRecording", "https://schema.chronicle.app/Person", "https://schema.chronicle.app/MusicAlbum", "https://schema.chronicle.app/Organization", "https://schema.chronicle.app/MusicGroup"], :domain=>["https://schema.chronicle.app/Activity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/endAt", :name_shortened=>"endAt", :name_snake_case=>"end_at", :range=>["https://schema.chronicle.app/DateTime"], :range_with_subclasses=>["https://schema.chronicle.app/DateTime"], :domain=>["https://schema.chronicle.app/Activity"], :cardinality=>:zero_or_one}], :subclasses=>[], :superclasses=>[], :dependencies=>[]}, "https://schema.chronicle.app/MusicRecording"=>{:name=>"https://schema.chronicle.app/MusicRecording", :name_short=>"MusicRecording", :properties=>[{:name=>"https://schema.chronicle.app/byArtist", :name_shortened=>"byArtist", :name_snake_case=>"by_artist", :range=>["https://schema.chronicle.app/MusicGroup", "https://schema.chronicle.app/Person", "https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/MusicGroup", "https://schema.chronicle.app/Person", "https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/MusicAlbum", "https://schema.chronicle.app/MusicRecording"], :cardinality=>:zero_or_more}, {:name=>"https://schema.chronicle.app/inAlbum", :name_shortened=>"inAlbum", :name_snake_case=>"in_album", :range=>["https://schema.chronicle.app/MusicAlbum"], :range_with_subclasses=>["https://schema.chronicle.app/MusicAlbum"], :domain=>["https://schema.chronicle.app/MusicRecording"], :cardinality=>:zero_or_more}, {:name=>"https://schema.chronicle.app/name", :name_shortened=>"name", :name_snake_case=>"name", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/description", :name_shortened=>"description", :name_snake_case=>"description", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/url", :name_shortened=>"url", :name_snake_case=>"url", :range=>["https://schema.chronicle.app/URL"], :range_with_subclasses=>["https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}], :subclasses=>[], :superclasses=>["https://schema.chronicle.app/CreativeWork", "https://schema.chronicle.app/Entity"], :dependencies=>["https://schema.chronicle.app/CreativeWork", "https://schema.chronicle.app/Entity"]}, "https://schema.chronicle.app/Organization"=>{:name=>"https://schema.chronicle.app/Organization", :name_short=>"Organization", :properties=>[{:name=>"https://schema.chronicle.app/name", :name_shortened=>"name", :name_snake_case=>"name", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/description", :name_shortened=>"description", :name_snake_case=>"description", :range=>["https://schema.chronicle.app/Text"], :range_with_subclasses=>["https://schema.chronicle.app/Text", "https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}, {:name=>"https://schema.chronicle.app/url", :name_shortened=>"url", :name_snake_case=>"url", :range=>["https://schema.chronicle.app/URL"], :range_with_subclasses=>["https://schema.chronicle.app/URL"], :domain=>["https://schema.chronicle.app/Entity"], :cardinality=>:zero_or_one}], :subclasses=>["https://schema.chronicle.app/MusicGroup"], :superclasses=>["https://schema.chronicle.app/Entity"], :dependencies=>["https://schema.chronicle.app/Entity"]}}
end