module Views
  module Tags
    module Posts
      class Index < Views::Base
        include Phlex::Rails::Helpers::LinkTo

        def initialize(posts:, pagy:, tag:)
          @posts = posts
          @pagy = pagy
          @tag = tag
        end

        def view_template(&)
          render Components::Page.new() do
            render Components::Box.new() do
              render Components::BoxHeader.new() do
                render Components::BoxNav.new() do |nav|
                  nav.item(tag_posts_path(@tag), active: :exact) { "Hot" }
                  nav.item(recent_tag_posts_path(@tag)) { "Recent" }
                end
              end

              render Components::BoxContent.new() do
                render Views::Posts::List.new(posts: @posts, pagy: @pagy)
              end
            end
          end
        end
      end
    end
  end
end
