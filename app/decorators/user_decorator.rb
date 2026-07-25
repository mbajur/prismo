# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  def to_s
    "@#{object.username}"
  end

  def display_name
    object.username
  end

  def path
    # if object.local?
    #   h.account_path(object)
    # else
    #   object.url
    # end
    h.user_path(object)
  end

  def url
    # if object.local?
    #   h.account_url(object)
    # else
    #   object.url
    # end
    h.user_url(object)
  end

  def username_with_at
    "@#{object.username}"
  end

  def profile_url
    h.account_url(object)
  end

  def network_url
    h.network_account_url(object.id)
  end

  def bio_html
    return if object.bio.blank?
    BodyParser.new(object.bio, markdown_renderer: Redcarpet::Render::UserBio).call.html_safe
  end

  def to_meta_tags
    {
      title: to_s,
      description: object.bio,
      alternate: [ {
        href: h.user_url(object), type: "application/activity+json"
      } ],
      og: {
        title: to_s
        # image: (object.avatar_url(:size_60) if object.avatar.present?)
      }
    }
  end
end
