module ActivityPub
  class UndoAnnounceActivityHandler
    def self.handle_undo_announce_request(activity_hash_or_id)
      activity = Fediverse::Request.dereference(activity_hash_or_id)
      actor = Fedipub::Actor.find_or_create_by_object(activity["actor"])
      object = Fediverse::Request.dereference(activity.dig("object", "object"))
      entity = Fedipub::Utils::Object.find_or_initialize(object)
      return unless entity.persisted?

      like = Fedipub::Activity.find_by(actor: actor, action: "Announce", entity: entity)
      like&.destroy
    end
  end
end
