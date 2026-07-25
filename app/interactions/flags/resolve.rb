# frozen_string_literal: true

class Flags::Resolve < ActiveInteraction::Base
  object :flag

  def execute
    flag.action_taken = true

    if flag.valid?
      flag.save
    else
      errors.merge!(flag.errors)
    end

    flag
  end
end
