# RailsSettings Model
class Setting < RailsSettings::Base
  cache_prefix { "v1" }

  field :site_title, type: :string, default: "△ Prismo"
  field :site_description, type: :string, default: "Prismo instance"
  field :comment_likes_per_day, type: :integer, default: 10
  field :posts_per_day, type: :integer, default: 5
  field :post_likes_per_day, type: :integer, default: 10
  field :min_story_tags, type: :integer, default: 1
  field :max_story_tags, type: :integer, default: 5
  field :post_title_update_time_limit, type: :integer, default: 60
  field :open_registrations, type: :boolean, default: true
  field :closed_registrations_message, type: :string, default: ""
  field :edit_counter_grace_period_minutes, type: :integer, default: 3
  field :webmentions_enabled, type: :boolean, default: true
end
