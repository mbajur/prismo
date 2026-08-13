module Fedipub
  class IncomingFediverseDataHandler < ApplicationJob
    def perform(incoming_activity)
      incoming_activity.processing!
      entity_class = incoming_activity.entity_class.constantize
      entity_class.handle_incoming_fediverse_data(incoming_activity.data)
      incoming_activity.processed!
      # rescue StandardError => e
      #   incoming_activity.failed!
      #   raise e
    end
  end
end
