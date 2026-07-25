# frozen_string_literal: true

class Settings::PreferencesController < ApplicationController
  before_action :authenticate_user!

  def show
    settings = Settings::UpdatePreferencesForm.new(user: current_user)

    render Views::Settings::Preferences::Show.new(settings: settings)
  end

  def update
    settings = Settings::UpdatePreferencesForm.run(
      settings_params.merge(user: current_user)
    )

    if settings.valid?
      redirect_to settings_preferences_path, notice: 'Preferences updated'
    else
      render Views::Settings::Preferences::Show.new(settings: settings), status: :unprocessable_entity
    end
  end

  private

  def settings_params
    params.require(:settings).permit(:theme)
  end
end
