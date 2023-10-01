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
      represents: 'identity',
      provider_id: '123'
    )
  end

  let (:activity) do
    a = Chronicle::Schema::Activity.new(
      verb: 'tested',
    )
    a.dedupe_on << ['provider', 'verb']
    a.actor = actor
    a
  end

  let (:track) do
    e = Chronicle::Schema::Entity.new(
      provider: 'foo',
      represents: 'music_recording',
      provider_url: 'adsfads'
    )
    e
  end

  let (:test_activitiy) do
    a = Chronicle::Schema::Activity.new(
      verb: 'watched',
      test: 'bar'
    )
    a.dedupe_on << ['provider', 'verb']
    a.involved = track
    a.actor = actor
    a
  end


  describe 'testing' do
    it 'foo' do
      # record = {data: Chronicle::Serialization::JSONAPISerializer.serialize(test_activitiy)}
      # res = Chronicle::Schema::Types::Activities::Test.call(record)
      # binding.pry
    end

    it 'testing or' do
      record = {
        type: 'entities',
        attributes: {
          provider: 'asdfadsf',
          represents: 'MusicAlbum',
          xprovider_id: 'asfas'
        },
        meta: {
          dedupe_on: [['provider', 'xprovider_id']]
        },
        relationships: {
          by_artist: {
            data: [{
              type: 'entities',
              attributes: {
                represents: 'RockGroup'
              },
              meta: {
                dedupe_on: [['provider', 'xprovider_id']]
              },
              relationships: {}
            }]
          }
        }
      }
      res = Chronicle::Schema::Types::MusicAlbumSchema.call(record)
      binding.pry
    end
  end

  describe 'in general' do
    it 'does not validate a non-entity or -activity' do
      expect do
        Chronicle::Schema::Validator.validate_jsonapi(
          type: 'foo',
          attributes: {},
          relationships: {},
          meta: {}
        )
      end.to raise_error(ArgumentError)
    end
  end

  describe 'entities' do
    it 'test' do
      entity = Chronicle::Schema::Entity.new(
        represents: 'music_recording',
        provider: 'foo',
        slug: 'test',
      )
      result = Chronicle::Schema::Validator.validate(entity)
    end

    it 'validates a basic entity' do
      result = Chronicle::Schema::Validator.validate(entity)
      expect(result[:success]).to be true
    end

    context 'for poorly formed dedupe_on values' do
      it 'does not validate whe missing dedupe_on' do
        entity.dedupe_on = nil
        result = Chronicle::Schema::Validator.validate(entity)
        expect(result[:success]).to be false
        expect(result[:errors]).to include(meta: a_hash_including(:dedupe_on))
      end
    end
  end


  describe 'activities' do
    it 'validates an activity' do
      result = Chronicle::Schema::Validator.validate(activity)
      expect(result[:success]).to be true

      # create an activity that has a non-actor for the actor
      activity.actor = entity
      result = Chronicle::Schema::Validator.validate(activity)
      expect(result[:success]).to be false
      expect(result[:errors]).to include(:relationships)
    end

    context "for poorly formed dedupe_on values" do
      it 'does not validate whe missing dedupe_on' do
        activity.dedupe_on = nil
        result = Chronicle::Schema::Validator.validate(activity)
        expect(result[:success]).to be false
        expect(result[:errors]).to include(meta: a_hash_including(:dedupe_on))
      end

      it 'does not validate when dedupe_on is not a nested array' do
        activity.dedupe_on = ['a']
        result = Chronicle::Schema::Validator.validate(activity)
        expect(result[:success]).to be false
        expect(result[:errors]).to include(meta: a_hash_including(:dedupe_on))
      end

      it 'does dedupe_on array values are not strings' do
        activity.dedupe_on = [[1]]
        result = Chronicle::Schema::Validator.validate(activity)
        expect(result[:success]).to be false
        expect(result[:errors]).to include(meta: a_hash_including(:dedupe_on))
      end
    end
  end
end
