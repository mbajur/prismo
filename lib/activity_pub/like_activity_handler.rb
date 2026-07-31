module ActivityPub
  class LikeActivityHandler
    def self.handle_like_activity(activity_hash_or_id)
      activity = Fediverse::Request.dereference(activity_hash_or_id)
      actor = Fedipub::Actor.find_or_create_by_object activity["actor"]
      object = Fediverse::Request.dereference(activity["object"])
      entity = Fedipub::Utils::Object.find_or_create!(object)
      raise ActiveRecord::RecordNotFound unless entity

      Fedipub::Activity.find_or_create_by(actor: actor, action: "Like", entity: entity, undone_at: nil)
      entity.cache_likes
    end
  end
end
