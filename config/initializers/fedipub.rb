require "fediverse/webfinger"
require "fediverse/inbox"
require "fedipub/data_transformer/note"

Fedipub.config_from "fedipub"

Fedipub.configure do |config|
  config.site_host = "https://#{ENV['HOST']}"
  config.open_registrations = -> { Setting.open_registrations }
end

Rails.application.config.after_initialize do
  Fedipub::Utils::JsonRequest::BASE_HEADERS = {
    "Content-Type" => 'application/ld+json;profile="https://www.w3.org/ns/activitystreams"',
    "Accept"       => 'application/ld+json;profile="https://www.w3.org/ns/activitystreams"'
  }

  Fediverse::Webfinger.class_eval do
    # This overwrite is here because lemmy expects application/activity+json as an Accept header value
    # I reported that to fedipub devs, will see how it ends up.
    def self.get_json(url, params = {})
      Fedipub::Utils::JsonRequest.get_json(url, params: params, follow_redirects: true, headers: { accept: "application/json, application/ld+json" })
    rescue Fedipub::Utils::JsonRequest::UnhandledResponseStatus => e
      Rails.logger.debug { e.message }

      raise ActiveRecord::RecordNotFound
    rescue Faraday::ConnectionFailed
      Rails.logger.debug { "Failed to reach server for GET #{url}" }

      raise ActiveRecord::RecordNotFound
    rescue JSON::ParserError
      Rails.logger.debug { "Invalid JSON response for GET #{url}" }

      raise ActiveRecord::RecordNotFound
    end
  end

  Fedipub::Actor.class_eval do
    _validators[:profile_url]
      .find { |v| v.is_a? ActiveRecord::Validations::PresenceValidator }
      .attributes
      .delete(:profile_url)

    _validators[:followings_url]
      .find { |v| v.is_a? ActiveRecord::Validations::PresenceValidator }
      .attributes
      .delete(:followings_url)

    _validators[:followers_url]
      .find { |v| v.is_a? ActiveRecord::Validations::PresenceValidator }
      .attributes
      .delete(:followers_url)
  end

  Fediverse::Inbox.register_handler("Like", "*", ActivityPub::LikeActivityHandler, :handle_like_activity)
  Fediverse::Inbox.register_handler("Undo", "Like", ActivityPub::UndoLikeActivityHandler, :handle_undo_like_request)
  Fediverse::Inbox.register_handler("Announce", "*", ActivityPub::AnnounceActivityHandler, :handle_announce_activity)
  Fediverse::Inbox.register_handler("Undo", "Announce", ActivityPub::UndoAnnounceActivityHandler, :handle_undo_announce_request)
end
