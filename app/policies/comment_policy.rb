# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.present? && !user.silenced? && !user.suspended?
  end

  def edit?
    user.present? && record.local_fedipub_entity? && (user.admin? || user == record.user)
  end

  def update?
    edit?
  end

  def comment?
    user.present? && !user.silenced? && !user.suspended?
  end

  def like?
    user.present? && !user.silenced? && !user.suspended?
  end

  def unlike?
    like?
  end

  def destroy?
    user.present? && record.local_fedipub_entity? && (user.admin? || user == record.user)
  end
end
