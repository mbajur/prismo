# frozen_string_literal: true

module Settings
  class UpdatePreferencesForm < ActiveInteraction::Base
    object :user
    string :theme

    validates :theme, presence: true
    validates :theme, allow_blank: true, inclusion: { in: User::Settings.themes.keys.map(&:to_s) }

    def initialize(args)
      super

      self.theme ||= args[:user].settings.theme || User::Settings.themes.keys.first
    end

    def execute
      user.settings.theme = theme if theme

      user.save
    end

    def persisted?
      true
    end
  end
end
