class Users::Follow < ActiveInteraction::Base
  object :follower, class: User
  object :followee, class: User

  def execute
    return if follower == followee

    follower.follow!(followee)
  end
end
