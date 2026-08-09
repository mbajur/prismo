# frozen_string_literal: true

class Comments::Unlike < ActiveInteraction::Base
  object :comment, class: Comment
  object :user, class: User

  def execute
    like = ::Like.find_by!(fedipub_actor: user.fedipub_actor, likeable: comment)

    like.destroy!
    Fedipub::Activity.find_by(actor: user.fedipub_actor, action: "Like", entity: comment)&.undo!
    Users::UpdateKarmaJob.perform_later(comment.user, "Comment", "remove")
  end
end
