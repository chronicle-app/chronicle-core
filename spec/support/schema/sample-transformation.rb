pick_subtype :Action do
  pick_property :endTime
  pick_property :startTime
  pick_property :agent
  pick_property :instrument
  pick_property :object
  pick_property :result
end

pick_subtype :Event do
  pick_all_subtypes
end

pick_subtype :Person do
  pick_property :address
end
pick_subtype :Organization
pick_property :name
pick_property :description
