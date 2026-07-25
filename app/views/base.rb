# frozen_string_literal: true

class Views::Base < Components::Base
  # The `Views::Base` is an abstract class for all your views.

  # By default, it inherits from `Components::Base`, but you
  # can change that to `Phlex::HTML` if you want to keep views and
  # components independent.

  # More caching options at https://www.phlex.fun/components/caching
  def cache_store = Rails.cache

  private

  def timeago(date, format: :long)
    return if date.blank?

    content = I18n.l(date, format: format)

    time(
      title: content,
      data: {
        controller: "timeago",
        timeago_datetime_value: date.iso8601
      }
    ) { content }
  end
end
