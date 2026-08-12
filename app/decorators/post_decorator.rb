# frozen_string_literal: true

class PostDecorator < Draper::Decorator
  include Rails.application.routes.url_helpers

  delegate_all

  def to_s
    object.title
  end

  def to_flag_title
    to_s
  end

  def path
    h.post_path(object)
  end

  def local_url
    post_url(object)
  end

  def domain
    return nil if !object.url.present?
    URI.parse(object.url).host
  end

  def score
    popularity + recentness
  end

  def popularity(weight: 3)
    object.likes_count * weight
  end

  def recentness(epoch: 1.day.ago.to_i, divisor: 3600)
    seconds = object.created_at.to_i - epoch
    (seconds / divisor).to_i
  end

  def description_html
    BodyParser.new(object.description).call.html_safe
  end

  def description_excerpt
    return nil if object.description.blank?
    h.strip_tags(description_html).truncate(100)
  end

  def excerpt
    if object.url_meta && object.url_meta.description
      object.url_meta.description
    else
      description_excerpt
    end
  end

  def thumb_url
    if object.local_fedipub_entity?
      object.thumb_url(:size_200) if object.thumb_data?
    else
      object.remote_image_url
    end
  end

  def to_meta_tags
    Rails.cache.fetch("#{object.cache_key_with_version}/meta_tags") do
      alternate = []
      alternate << {
        href: object.federated_url, type: "application/activity+json"
      } if object.local_fedipub_entity?

      {
        title: object.title,
        description: excerpt,
        alternate: alternate,
        og: {
          title: object.title,
          image: (object.thumb_url(:size_200) if object.thumb.present?)
        }
      }
    end
  end
end
