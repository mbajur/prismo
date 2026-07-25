# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.present? && !user.silenced? && !user.suspended?
  end

  def update?
    user.present? && (user.admin? || user == record.user)
  end

  def comment?
    user.present? && !user.silenced? && !user.suspended?
  end

  def toggle_like?
    user.present? && !user.silenced? && !user.suspended?
  end

  def destroy?
    user.present? && (user.admin? || user == record.user)
  end
end
