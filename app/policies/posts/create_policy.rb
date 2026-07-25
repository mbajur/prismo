# frozen_string_literal: true

class Posts::CreatePolicy < PostPolicy
  def update_url?
    true
  end
end
