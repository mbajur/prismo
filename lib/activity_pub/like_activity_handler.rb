module ActivityPub
  class LikeActivityHandler
    def self.handle_like_activity(activity_hash_or_id)
      activity = Fediverse::Request.dereference(activity_hash_or_id)
      actor = Fedipub::Actor.find_or_create_by_object activity["actor"]
      object = Fediverse::Request.dereference(activity["object"])
      entity = Fedipub::Utils::Object.find_or_create!(object)
      raise ActiveRecord::RecordNotFound unless entity

      like = Like.find_or_initialize_by(likeable: entity, fedipub_actor: actor)
      if like.new_record?
        like.save!
        entity.like!(actor: actor)
        entity.cache_likes
      end
    end
  end
end
