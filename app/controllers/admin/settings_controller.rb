# frozen_string_literal: true

module Admin
  class SettingsController < BaseController
    ADMIN_SETTINGS = %w[
      site_title
      site_description
      posts_per_day
      post_likes_per_day
      comment_likes_per_day
      open_registrations
      webmentions_enabled
      closed_registrations_message
      post_title_update_time_limit
      edit_counter_grace_period_minutes
    ].freeze

    BOOLEAN_SETTINGS = %w[
      open_registrations
      webmentions_enabled
    ].freeze

    UPLOAD_SETTINGS = %w[].freeze

    def edit
      authorize :admin
      @admin_settings = Form::AdminSettings.new

      render Views::Admin::Settings::Edit.new(admin_settings: @admin_settings)
    end

    def update
      authorize :admin

      settings_params.each do |key, value|
        if UPLOAD_SETTINGS.include?(key)
          upload = SiteUpload.where(var: key).first_or_initialize(var: key)
          upload.update(file: value)
        else
          setting = Setting.where(var: key).first_or_initialize(var: key)
          setting.update(value: value_for_update(key, value))
        end
      end

      flash[:notice] = I18n.t("generic.changes_saved_msg")
      redirect_to edit_admin_settings_path
    end

    private

    def settings_params
      params.require(:form_admin_settings).permit(ADMIN_SETTINGS)
    end

    def value_for_update(key, value)
      if BOOLEAN_SETTINGS.include?(key)
        value == "1"
      else
        value
      end
    end
  end
end
