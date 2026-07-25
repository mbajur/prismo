# frozen_string_literal: true

class Flags::Unresolve < ActiveInteraction::Base
  object :flag

  def execute
    flag.action_taken = false

    if flag.valid?
      flag.save
    else
      errors.merge!(flag.errors)
    end

    flag
  end
end
