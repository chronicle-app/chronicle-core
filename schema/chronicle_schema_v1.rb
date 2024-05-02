version 1
set_base_graph 'schema.org', '26.0'

pick_type :Thing do
  pick_type :Action do
    apply_property :endTime
    apply_property :startTime
    apply_property :agent, required: true
    apply_property :instrument
    apply_property :object
    apply_property :result

    pick_type :AssessAction do
      pick_type :ReactAction do
        pick_type :LikeAction
      end
    end

    pick_type :ConsumeAction do
      pick_type :ListenAction
      pick_type :ReadAction
      pick_type :UseAction
      pick_type :ViewAction
      pick_type :WatchAction
    end

    pick_type :ControlAction

    pick_type :InteractAction do
      pick_type :CommunicateAction do
        pick_type :CheckInAction
        pick_type :CommentAction
      end
    end

    pick_type :OrganizeAction do
      pick_type :BookmarkAction
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
  end

  pick_type :CreativeWork do
    pick_type :Book do
      apply_property :numberOfPages
    end

    pick_type :CreativeWorkSeries do
      pick_type :PodcastSeries do
        apply_property :webFeed
      end
    end

    add_type :ComputerCommand, comment: 'A command that can be executed on a computer.'

    pick_type :Comment

    pick_type :Episode do
      pick_type :PodcastEpisode

      apply_property :partOfSeason
      apply_property :partOfSeries
      apply_property :duration
      apply_property :episodeNumber
    end

    pick_type :MediaObject do
      pick_type :AudioObject
      pick_type :ImageObject
      pick_type :VideoObject

      apply_property :duration
      apply_property :width
      apply_property :height
    end

    pick_type :MusicPlaylist do
      pick_type :MusicAlbum do
        apply_property :byArtist, many: true
      end
    end

    pick_type :MusicRecording do
      apply_property :inAlbum, many: true
      apply_property :byArtist, many: true
      apply_property :duration
    end

    pick_type :Message do
      apply_property :recipient, many: true
      apply_property :sender
    end

    apply_property :about, many: true
    apply_property :aggregateRating
    apply_property :author, many: true
    apply_property :contributor, many: true
    apply_property :contentLocation, many: true
    apply_property :creator, many: true
    apply_property :inLanguage, many: true
    apply_property :isPartOf, many: true
    apply_property :mentions, many: true
    apply_property :producer, many: true
    apply_property :publisher, many: true
    apply_property :text
  end

  pick_type :Intangible do
    pick_type :Quantity do
      pick_type :Duration
      pick_type :Distance
      pick_type :Energy
      pick_type :Mass
    end

    pick_type :StructuredValue do
      pick_type :ContactPoint do
        pick_type :PostalAddress do
          apply_property :addressCountry
          apply_property :addressLocality
          apply_property :addressRegion
          apply_property :postOfficeBoxNumber
          apply_property :postalCode
          apply_property :streetAddress
        end
      end
      pick_type :QuantitativeValue do
        apply_property :value
      end
    end
  end

  pick_type :Organization

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

    apply_property :address
    apply_property :latitude
    apply_property :longitude
  end

  apply_property :alternateName
  apply_property :description
  apply_property :identifier
  apply_property :image
  apply_property :name
  apply_property :subjectOf, many: true
  apply_property :url

  # TODO: Make these subproperties of identifier, alternateName
  add_property :source
  add_property :slug
  add_property :sourceId
  add_property :sourceNamespace

  # allow keywords on everything
  add_property :keywords, many: true
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
