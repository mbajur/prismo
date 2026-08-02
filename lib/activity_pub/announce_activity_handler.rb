module ActivityPub
  class AnnounceActivityHandler
    def self.handle_announce_activity(activity_hash_or_id)
      activity = Fediverse::Request.dereference(activity_hash_or_id)
      actor = Fedipub::Actor.find_or_create_by_object activity["actor"]
      object = Fediverse::Request.dereference(activity["object"])
      entity = Fedipub::Utils::Object.find_or_create!(object)
      raise ActiveRecord::RecordNotFound unless entity

      entity.announce!(actor: actor)
    end
  end
end
