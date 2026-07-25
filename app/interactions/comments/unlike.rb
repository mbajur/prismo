# frozen_string_literal: true

class Comments::Unlike < ActiveInteraction::Base
  object :comment, class: Comment
  object :user, class: User

  def execute
    like = ::Like.find_by(user: user, likeable: comment)

    if like.present?
      like.destroy
      # Accounts::UpdateKarmaJob.perform_later(comment.user.id, "Comment", "remove")
      # ActivityPub::UndoLikeDistributionJob.call(like) if !comment.user.local?
    end
    # Stories::BroadcastChanges.run! story: story.reload

    like
  end
end
