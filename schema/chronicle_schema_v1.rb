version 1
set_base_graph 'schema.org', 'latest'

pick_subclass :Thing do
  pick_subclass :Action do
    apply_property :endTime
    apply_property :startTime
    apply_property :agent, required: true
    apply_property :instrument
    apply_property :object
    apply_property :result

    # pick_subclass :SearchAction
    pick_subclass :ConsumeAction do
      pick_subclass :ListenAction
    end

    pick_subclass :UpdateAction do
      pick_subclass :AddAction do
        pick_subclass :InsertAction
      end
    end
  end

  pick_subclass :Event do
    apply_property :location, many: true
    apply_property :startDate
    apply_property :endDate
    # pick_all_subclasses
  end

  pick_subclass :CreativeWork do
    pick_subclass :MusicPlaylist do
      pick_subclass :MusicAlbum do
        apply_property :byArtist, many: true
      end
    end
    pick_subclass :MusicRecording do
      apply_property :inAlbum, many: true
      apply_property :byArtist, many: true
    end

    apply_property :about, many: true
  end

  pick_subclass :Person do
    apply_property :address
  end
  pick_subclass :Organization do
    apply_property :location, many: true
    pick_subclass :PerformingGroup do
      pick_subclass :MusicGroup do
        apply_property :album, many: true
      end
    end
  end

  pick_subclass :Place do
    pick_subclass :AdministrativeArea do
      pick_all_subclasses
    end
  end

  apply_property :alternateName
  apply_property :description
  apply_property :identifier
  apply_property :name
  apply_property :subjectOf, many: true
  apply_property :url

  # TODO: Make these subproperties of identifier, alternateName
  add_property :source
  add_property :slug
  add_property :sourceId
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
