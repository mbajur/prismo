# frozen_string_literal: true

module Redcarpet
  module Render
    class UserBio < Redcarpet::Render::Base
      def paragraph(text)
        "<p>#{text}</p>"
      end

      def header(text, header_level)
        '<p>' + '#' * header_level + text + '</p>'
      end

      def block_html(raw_html)
        raw_html
      end
    end
  end
end
