module Fedipub
  class IncomingFediverseDataHandlerJob < ApplicationJob
    def perform(incoming_activity)
      incoming_activity.processing!
      entity_class = incoming_activity.entity_class.constantize
      entity_class.handle_incoming_fediverse_data(activity_hash_or_id(incoming_activity.data))
      incoming_activity.processed!
    rescue StandardError => e
      incoming_activity.failed!
      raise e
    end

    private

    # `data` is either a full activity hash, or a { "id" => url } wrapper used to store a bare URL/ID.
    def activity_hash_or_id(data)
      data.keys == [ "id" ] ? data["id"] : data
    end
  end
end
