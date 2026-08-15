module Comments
  class IncomingFediverseDataHandler
    def initialize(activity_hash_or_id)
      @activity_hash_or_id = activity_hash_or_id
    end

    def call
      activity = Fediverse::Request.dereference(@activity_hash_or_id)
      object = Fediverse::Request.dereference(activity["object"])

      entity = Fedipub::Utils::Object.find_or_create!(object)

      if activity["type"] == "Update"
        entity.assign_attributes Comment.from_activitypub_object(object)

        # Use timestamps from attributes
        entity.save! touch: false
      end

      handle_mentions(entity, object)

      entity
    end

    private

    def handle_mentions(entity, object)
      tag = object["tag"] || []
      tags = tag.is_a?(Hash) ? [ tag ] : tag
      mentions = tags.filter { |tag| tag["type"] == "Mention" }

      # Remove mentions that are no longer present in the activity
      mentions_hrefs = mentions.map { |tag| tag["href"] }
      entity.fedipub_mentions.find_each do |existing_mention|
        existing_mention.destroy! if !mentions_hrefs.include?(existing_mention.actor.federated_url)
      end

      # Add new mentions that are not already present
      mentions.each do |mention|
        actor = Fedipub::Actor.find_or_create_by_federation_url(mention["href"])
        Fedipub::Mention.find_or_create_by!(actor: actor, entity: entity)
      rescue StandardError => e
        Rails.logger.error "Failed to handle mention: #{e.message}"
        Rails.error.report(e)
        next
      end
    end
  end
end
