# frozen_string_literal: true

class Posts::Unlike < ActiveInteraction::Base
  object :post, class: Post
  object :user, class: User

  def execute
    like = ::Like.find_by(user: user, likeable: post)

    if like.present?
      like.destroy
      # Accounts::UpdateKarmaJob.perform_later(post.account.id, "Story", "remove")
    end

    like
  end
end
