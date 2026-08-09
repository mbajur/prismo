module ActivityPub
  class UndoLikeActivityHandler
    def self.handle_undo_like_request(activity_hash_or_id)
      activity = Fediverse::Request.dereference(activity_hash_or_id)
      actor = Fedipub::Actor.find_or_create_by_object(activity["actor"])
      object = Fediverse::Request.dereference(activity.dig("object", "object"))
      entity = Fedipub::Utils::Object.find_or_initialize(object)
      return unless entity.persisted?

      like = Like.find_by(fedipub_actor: actor, likeable: entity)

      if like
        like.destroy
        entity.cache_likes
      end

      activity = Fedipub::Activity.find_by(actor: actor, action: "Like", entity: entity)
      activity&.undo!
    end
  end
end
