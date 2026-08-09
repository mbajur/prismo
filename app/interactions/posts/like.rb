# frozen_string_literal: true

class Posts::Like < ActiveInteraction::Base
  object :post, class: Post
  object :user, class: User

  def to_model
    ::Like.new
  end

  def execute
    user.touch(:last_active_at)
    like = Like.find_or_initialize_by(
      likeable: post,
      fedipub_actor: user.fedipub_actor
    )

    if like.new_record?
      like.save!
      post.like!(actor: user.fedipub_actor)

      Users::UpdateKarmaJob.perform_later(post.user, "Post")
    end
  end
end
