# frozen_string_literal: true

class Posts::Like < ActiveInteraction::Base
  object :post, class: Post
  object :user, class: User

  def to_model
    ::Like.new
  end

  def execute
    user.touch(:last_active_at)
    post.like!(actor: user.fedipub_actor)
    post.cache_likes

    Users::UpdateKarmaJob.perform_later(post.user, "Post")
  end
end
