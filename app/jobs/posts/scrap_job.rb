# frozen_string_literal: true

require "open-uri"

module Posts
  class ScrapJob < ApplicationJob
    include ActionView::Helpers::TextHelper

    queue_as :default

    def perform(post)
      @attributes = {}
      @post = post
      return if post.url.blank?

      begin
        thumbnailer
      rescue LinkThumbnailer::FormatNotSupported => e
        logger.tagged("post-#{post.id}") do
          "MIME type of #{post.url} not supported (#{e.message})"
        end
      else
        set_basic_attributes!
        set_thumb_attributes!

        save_url_meta!
      ensure
        post.touch(:scrapped_at)
        # Stories::BroadcastChanges.run!(story: story)
      end
    end

    private

    attr_reader :post, :attributes

    def set_basic_attributes!
      @attributes.merge!(
        title:       strip_tags(thumbnailer.title),
        description: strip_tags(thumbnailer.description)
      )
    end

    def set_thumb_attributes!
      return if thumbnailer.images.empty?

      thumb_uri = thumbnailer&.images&.first&.src
      return if thumb_uri.nil?

      @attributes.merge! thumb_remote_url: thumb_uri
    end

    def save_url_meta!
      url_meta = post.url_meta || UrlMeta.new

      url_meta.assign_attributes(attributes)
      url_meta.save!
      post.update!(url_meta: url_meta)
    end

    def thumbnailer
      @thumbnailer ||= LinkThumbnailer.generate(post.url)
    end
  end
end
