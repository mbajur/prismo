# frozen_string_literal: true

class AdminPolicy < ApplicationPolicy
  def edit?
    user.admin?
  end

  def update?
    edit?
  end
end
