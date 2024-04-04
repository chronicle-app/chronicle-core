version 1
set_base_graph 'schema.org', 'latest'

pick_type :Thing do
  pick_type :Action do
    apply_property :endTime
    apply_property :startTime
    apply_property :agent, required: true
    apply_property :instrument
    apply_property :object
    apply_property :result

    # pick_type :SearchAction
    pick_type :ConsumeAction do
      pick_type :ListenAction
    end

    pick_type :InteractAction do
      pick_type :CommunicateAction
    end

    pick_type :UpdateAction do
      pick_type :AddAction do
        pick_type :InsertAction
      end
    end
  end

  pick_type :Event do
    apply_property :location, many: true
    apply_property :startDate
    apply_property :endDate
    # pick_all_subtypes
  end

  pick_type :CreativeWork do
    pick_type :MusicPlaylist do
      pick_type :MusicAlbum do
        apply_property :byArtist, many: true
      end
    end
    pick_type :MusicRecording do
      apply_property :inAlbum, many: true
      apply_property :byArtist, many: true
    end

    pick_type :Message do
      apply_property :recipient, many: true
      apply_property :sender
    end

    apply_property :text
    apply_property :about, many: true
  end

  pick_type :Person do
    apply_property :address
  end
  pick_type :Organization do
    apply_property :location, many: true
    pick_type :PerformingGroup do
      pick_type :MusicGroup do
        apply_property :album, many: true
      end
    end
  end

  pick_type :Place do
    pick_type :AdministrativeArea do
      pick_all_subtypes
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
  add_property :sourceNamespace
end

pick_type :DataType do
  pick_type :Number do
    pick_type :Integer
    pick_type :Float
  end
  pick_type :Boolean
  pick_type :Text do
    pick_type :URL
  end
  pick_type :Date
  pick_type :DateTime
end
