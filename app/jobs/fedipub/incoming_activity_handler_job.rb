module Fedipub
  class IncomingActivityHandlerJob < ApplicationJob
    def perform(entity_class:, activity_hash_or_id:)
      entity_class = entity_class.constantize
      entity_class.handle_incoming_fediverse_data(activity_hash_or_id)
    end
  end
end
