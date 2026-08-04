# frozen_string_literal: true

class Comments::Like < ActiveInteraction::Base
  object :comment, class: Comment
  object :user, class: User

  def to_model
    ::Like.new
  end

  def execute
    user.touch(:last_active_at)
    comment.like!(actor: user.fedipub_actor)
    comment.cache_likes

    Users::UpdateKarmaJob.perform_later(comment.user, "Comment")
  end
end
