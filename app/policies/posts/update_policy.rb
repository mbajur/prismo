# frozen_string_literal: true

class Posts::UpdatePolicy < PostPolicy
  # @todo move that to PostPolicy
  def update_url?
    user.admin?
  end
end
