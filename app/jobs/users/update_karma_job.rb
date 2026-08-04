# frozen_string_literal: true

module Users
  class UpdateKarmaJob < ApplicationJob
    queue_as :default

    def perform(user, resource_type, add_or_remove = "add")
      method = add_or_remove == "add" ? :increment! : :decrement!

      case resource_type
      when "Comment" then user.send(method, :comments_karma)
      when "Post" then user.send(method, :posts_karma)
      else logger.warn "Unknown resource type #{resource_type}"
      end

      true
    end
  end
end
