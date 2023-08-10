require 'spec_helper'

RSpec.describe Chronicle::Schema::Validator do

  let (:entity) do
    Chronicle::Schema::Entity.new(
      provider: 'foo',
      title: 'test',
      represents: 'foo'
    )
  end

  let (:actor) do
    Chronicle::Schema::Entity.new(
      provider: 'foo',
      represents: 'identity'
    )
  end

  let (:activity) do
    a = Chronicle::Schema::Activity.new(
      verb: 'tested',
    )
    a.actor = actor
    a
  end

  it 'validates an entity' do
    result = Chronicle::Schema::Validator.validate(entity)
    expect(result[:success]).to be true
  end

  it 'validates an activity' do
    result = Chronicle::Schema::Validator.validate(activity)
    expect(result[:success]).to be true

    # create an activity that has a non-actor for the actor
    activity.actor = entity
    result = Chronicle::Schema::Validator.validate(activity)
    expect(result[:success]).to be false
    expect(result[:errors]).to include(:relationships)
  end
end
