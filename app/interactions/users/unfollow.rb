class Users::Unfollow < ActiveInteraction::Base
  object :follower, class: User
  object :followee, class: User

  def execute
    return if follower == followee

    follower.unfollow!(followee)
  end
end
