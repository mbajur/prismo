# frozen_string_literal: true

class Form::AdminSettings
  include ActiveModel::Model

  delegate(
    :site_title,
    :site_title=,
    :site_description,
    :site_description=,
    :open_registrations,
    :open_registrations=,
    :closed_registrations_message,
    :closed_registrations_message=,
    :posts_per_day,
    :posts_per_day=,
    :post_likes_per_day,
    :post_likes_per_day=,
    :comment_likes_per_day,
    :comment_likes_per_day=,
    :post_title_update_time_limit,
    :post_title_update_time_limit=,
    :edit_counter_grace_period_minutes,
    :edit_counter_grace_period_minutes=,
    :webmentions_enabled,
    :webmentions_enabled=,
    to: Setting
  )
end
