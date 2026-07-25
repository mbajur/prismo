# frozen_string_literal: true

module Users
  class SuspendJob < ApplicationJob
    queue_as :default

    def perform(user)
      Users::SuspendService.new.call(user)
    end
  end
end
