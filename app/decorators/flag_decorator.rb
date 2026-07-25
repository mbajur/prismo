# frozen_string_literal: true

class FlagDecorator < Draper::Decorator
  delegate_all

  def path
    h.admin_flag_path(object.id)
  end
end
