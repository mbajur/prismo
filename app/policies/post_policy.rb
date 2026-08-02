# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.present? && !user.silenced? && !user.suspended?
  end

  def edit?
    user.present? && (user.admin? || user == record.user)
  end

  def update?
    edit?
  end

  def update_title?
    # First check if user is admin
    return true if user.admin?

    # Then check if limit is not disabled
    limit = Setting.post_title_update_time_limit.to_i
    return true if limit.zero? && edit?

    diff = ((Time.current - record.created_at) / 1.minute).to_i

    edit? && diff < limit
  end

  def scrap?
    user.present? && (user.admin? || user == record.user)
  end

  def comment?
    user.present? && !user.silenced? && !user.suspended?
  end

  def like?
    user.present? &&
      !record.discarded? &&
      !user.silenced? && !user.suspended?
  end

  def unlike?
    like?
  end

  def destroy?
    user.present? && (user == record.user || user.admin?)
  end
end
