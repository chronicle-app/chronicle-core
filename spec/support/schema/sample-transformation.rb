pick_subclass :Action do
  pick_property :endTime
  pick_property :startTime
  pick_property :agent
  pick_property :instrument
  pick_property :object
  pick_property :result
end

pick_subclass :Event do
  pick_all_subclasses
end

pick_subclass :Person do
  pick_property :address
end
pick_subclass :Organization
pick_property :name
pick_property :description
