# frozen_string_literal: true

class Posts::Like < ActiveInteraction::Base
  object :post, class: Post
  object :user, class: User

  def to_model
    ::Like.new
  end

  def execute
    return existing_like if existing_like.present?

    like = ::Like.new(likeable: post)
    like.user = user

    if like.save
      # user.touch(:last_active_at)
      # Accounts::UpdateKarmaJob.perform_later(post.user.id, "Post")
      # Posts::BroadcastChanges.run! post: post
    else
      errors.merge!(like.errors)
    end

    like
  end

  private

  def existing_like
    @existing_like ||= ::Like.find_by(likeable: post, user: user)
  end
end
