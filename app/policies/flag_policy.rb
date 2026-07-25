# frozen_string_literal: true

class FlagPolicy < ApplicationPolicy
  def index?
    user.present? && user.admin?
  end

  def new?
    user.present? && !user.silenced?
  end

  def create?
    user.present? && !user.silenced?
  end

  def edit?
    user.account == record.actor || user.admin?
  end

  def update?
    user.account == record.actor || user.admin?
  end

  def resolve?
    user.present? && user.admin?
  end

  def unresolve?
    user.present? && user.admin?
  end
end
