# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def follow?
    user.present?
  end

  def unfollow?
    follow?
  end

  def suspend?
    user.present? && user != record && !record.suspended?
  end

  def silence?
    user.present? && user != record && !record.suspended?
  end

  def unsilence?
    user.present? && user != record && !record.suspended?
  end
end
