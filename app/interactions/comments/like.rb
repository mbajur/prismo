# frozen_string_literal: true

class Comments::Like < ActiveInteraction::Base
  object :comment, class: Comment
  object :user, class: User

  def to_model
    ::Like.new
  end

  def execute
    return existing_like if existing_like.present?

    like = ::Like.new(likeable: comment)
    like.user = user

    if like.save
      # user.touch(:last_active_at)
      # Accounts::UpdateKarmaJob.perform_later(comment.account.id, "Comment")
      # ActivityPub::LikeDistributionJob.perform_later(like.id) unless comment.account.local?
    else
      errors.merge!(like.errors)
    end

    like
  end

  private

  def existing_like
    @existing_like ||= ::Like.find_by(likeable: comment, user: user)
  end
end
