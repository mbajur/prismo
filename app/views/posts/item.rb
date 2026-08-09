module Views
  module Posts
    class Item < Views::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::Pluralize
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::ButtonTo

      def initialize(post:)
        @post = post.decorate
        @user = post.fedipub_actor.decorate
        @group = post.group.decorate
        @tags = @post.tags.to_a
      end

      def view_template(&)
        div(class: "flex gap-4 pb-4", id: dom_id(@post)) do
          div(class: "w-30") do
            a(href: post_path(@post), class: "bg-muted aspect-square block rounded-sm relative") do
              if @post.article?
                render Components::Icons::Text.new(class: "w-4 h-4 text-muted-foreground/30 m-auto absolute top-1/2 left-1/2 -translate-y-1/2 -translate-x-1/2 z-2")
              else
                render Components::Icons::Link.new(class: "w-4 h-4 text-muted-foreground/30 m-auto absolute top-1/2 left-1/2 -translate-y-1/2 -translate-x-1/2 z-2")
              end


              img(src: @post.thumb_url, class: "w-full rounded-xs z-10 relative", loading: :lazy) if @post.thumb_url
            end
          end

          div(class: "flex flex-col flex-1 gap-1") do
            h3(class: "font-bold") do
              if @post.url.present?
                link_to @post.title, @post.url, target: "_blank", rel: "noopener noreferrer"
              else
                link_to @post.title, post_path(@post)
              end
            end

            ul(class: "flex items-center gap-3 text-sm text-gray-500") do
              li do
                link_to(@user, @user.path)

                if !@group.supergroup?
                  span { " ▸ " }
                  link_to(@group, @group.path)
                end
              end
              li { @post.url_domain } if @post.url_domain.present?

              primary_tags.each do |tag|
                li { link_to "##{tag.name}", tag_posts_path(tag.name) }
              end

              li { "+#{secondary_tags.count} more" } if secondary_tags.any?
            end

            div(class: "text-sm") do
              @post.decorate.excerpt
            end

            ul(class: "flex items-center gap-3 text-sm text-gray-500") do
              li { render Views::Posts::LikeBtn.new(post: @post) }
              li { pluralize(@post.comments_count, "comment") }
              li do
                link_to(@post.decorate.path) do
                  span { "posted " }
                  span { timeago(@post.created_at) }
                  span { " ago" }
                end
              end

              li { link_to("edit", edit_post_path(@post)) } if policy(@post).edit?
            end
          end
        end
      end

      private

      def primary_tags
        @tags.first(2)
      end

      def secondary_tags
        @tags.drop(2)
      end
    end
  end
end
