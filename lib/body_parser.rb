# frozen_string_literal: true

# Parses raw markdown body of comment/post/bio and strips any unwanted tags,
# and converts markdown to safe HTML.
class BodyParser
  include ActionView::Helpers::SanitizeHelper

  def initialize(body, markdown_renderer: Redcarpet::Render::HTML)
    @body = body.to_s
    @markdown_renderer = markdown_renderer
  end

  def call
    sanitize!
    parse_mentions!
    convert_to_markdown!
    autolink!

    body
  end

  private

  attr_accessor :body, :markdown_renderer

  def markdown_parser
    @markdown_parser ||= Redcarpet::Markdown.new(markdown_renderer,
                                                 tables: true)
  end

  def sanitize!
    @body = sanitize(body, attributes: %w[href title rel])
  end

  def parse_mentions!
    @body = body.gsub(User::MENTION_RE) do |x|
      username, domain = x.split('@').reject(&:blank?)

      if domain.present?
        "<a href=\"https://#{domain}/@#{username}\">@#{username}</a>"
      else
        "<a href=\"\/@#{username}\">@#{username}</a>"
      end
    end
  end

  def autolink!
    @body = Rinku.auto_link(body, :urls)
  end

  def convert_to_markdown!
    @body = markdown_parser.render(body)
  end
end
