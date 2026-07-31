# frozen_string_literal: true

class Comments::Unlike < ActiveInteraction::Base
  object :comment, class: Comment
  object :user, class: User

  def execute
    # like = ::Like.find_by(user: user, likeable: comment)

    # if like.present?
    #   like.destroy
    #   # Accounts::UpdateKarmaJob.perform_later(comment.user.id, "Comment", "remove")
    #   activity = Fedipub::Activity.find_by(action: "Like", actor: user.fedipub_actor, entity: comment)
    #   activity&.undo!
    #   pp activity
    #   activity&.destroy!

    #   comment.cache_likes
    # end
    # Stories::BroadcastChanges.run! story: story.reload

    activity = Fedipub::Activity.find_by(action: "Like", actor: user.fedipub_actor, entity: comment, undone_at: nil)
    activity&.undo!
    activity&.touch(:undone_at)

    comment.cache_likes
  end
end
