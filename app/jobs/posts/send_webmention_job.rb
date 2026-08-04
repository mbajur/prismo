# frozen_string_literal: true

module Posts
  class SendWebmentionJob < ApplicationJob
    queue_as :webmentions

    def perform(post)
      return unless Setting.webmentions_enabled

      post = post.decorate
      return unless post.link?

      response = Webmention.send_webmention(post.local_url, post.url)

      if response.ok?
        post.update(webmentioned: true)
        logger.info "Webmention sent from #{post.local_url} to #{post.url}"
      else
        logger.warn "Failed to send webmention: #{response.message}"
      end
    end
  end
end
