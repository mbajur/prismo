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
      source = object["content"]
      source_plain = Nokogiri::HTML(source).text
      mentions = source_plain.scan(/@\w+(?:@\w+)?(?:\.\w+)*/)

      entity.fedipub_mentions.find_each do |existing_mention|
        existing_mention.destroy! if !mentions.include?(existing_mention.actor.at_address) # @todo should we handle short_at_address?
      end

      mentions.each do |mention|
        actor = Fedipub::Actor.find_or_create_by_account(mention)
        Fedipub::Mention.find_or_create_by!(actor: actor, entity: entity)
      rescue StandardError => e
        Rails.logger.error "Failed to handle mention: #{e.message}"
        Rails.error.report(e)
        next
      end
    end
  end
end
