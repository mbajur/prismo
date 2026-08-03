module Views
  module Posts
    class Guidelines < Views::Base
      include Phlex::Rails::Helpers::T

      def view_template(&)
        div(class: "flex flex-col gap-4") do
          render Components::Box.new() do
            render Components::BoxContent.new(class: "text-sm") do
              p(class: "mb-2") { "This community strives for quality content, and bans users very liberally, so behave yourself:" }

              ul(class: "mb-2 list-disc pl-4") do
                li { "Be nice. Or else." }
                li { "Self-promotion is acceptable, as long as it's not for paid goods." }
                li { "Clickbait titles are not welcome." }
                li { "Titles should be clear and free of extranous components." }
                li { "Links older than a year should have year of their creation parenthesised in the story title." }
                li { "Use description field only for no-url stories or when additional context or explanation for the URL is needed." }
              end
            end
          end

          # render Components::Box.new() do
          #   render Components::BoxContent.new(class: "text-sm") do
          #     p(class: "mb-4") { t(".bookmarklet_description") }

          #     Link(href: bookmarklet_href, variant: :secondary, class: "w-full") do
          #       t(".add_to", site_title: Setting.site_title)
          #     end
          #   end
          # end
        end
      end

      private

      # @todo drop URI.escape
      def bookmarklet_href
        URI.escape "javascript:(function(){javascript:location.href='#{new_post_url}?url='+encodeURIComponent(location.href)+'&title='+encodeURIComponent(document.title)})()" # rubocop:disable Lint/UriEscapeUnescape
      end
    end
  end
end
