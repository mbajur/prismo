# frozen_string_literal: true

class Posts::Unlike < ActiveInteraction::Base
  object :post, class: Post
  object :user, class: User

  def execute
    like = ::Like.find_by!(fedipub_actor: user.fedipub_actor, likeable: post)

    like.destroy!
    Fedipub::Activity.find_by(actor: user.fedipub_actor, action: "Like", entity: post)&.undo!
    Users::UpdateKarmaJob.perform_later(post.user, "Post", "remove")
  end
end
