version 1.2
set_base_graph 'schema.org', 'latest'

pick_subclass :Thing do
  pick_subclass :Action do
    pick_property :endTime
    pick_property :startTime
    pick_property :agent
    pick_property :instrument
    pick_property :object
    pick_property :result

    # pick_subclass :SearchAction
    pick_subclass :UpdateAction do
      pick_subclass :AddAction do
        pick_subclass :InsertAction
      end
    end
  end

  pick_subclass :Event do
    pick_property :location, required: true
    pick_property :startDate
    pick_property :endDate
    # pick_all_subclasses
  end

  pick_subclass :CreativeWork do
    pick_subclass :MusicPlaylist do
      pick_subclass :MusicAlbum do
        pick_property :byArtist, many: true
      end
    end
    pick_subclass :MusicRecording do
      pick_property :inAlbum, many: true
      pick_property :byArtist, many: true
    end

    pick_property :about, many: true
  end

  pick_subclass :Person do
    pick_property :address
  end
  pick_subclass :Organization do
    pick_property :location, many: true
    pick_subclass :PerformingGroup do
      pick_subclass :MusicGroup do
        pick_property :album, many: true
      end
    end
  end

  pick_subclass :Place do
  end

  pick_property :alternateName
  pick_property :description
  pick_property :identifier
  pick_property :name
  pick_property :subjectOf, many: true
  pick_property :url
end

pick_subclass :DataType do
  pick_subclass :Number do
    pick_subclass :Integer
    pick_subclass :Float
  end
  pick_subclass :Boolean
  pick_subclass :Text do
    pick_subclass :URL
  end
  pick_subclass :Date
  pick_subclass :DateTime
end
