module Views
  module Posts
    class Index < Views::Base
      include Phlex::Rails::Helpers::LinkTo

      def initialize(posts:, pagy:)
        @posts = posts
        @pagy = pagy
      end

      def view_template(&)
        render Components::Page.new() do
          render Views::Tags::HeadBox.new()

          render Components::Box.new() do
            render Components::BoxHeader.new() do
              render Components::BoxNav.new() do |nav|
                nav.item(root_path, active: :exact) { "Hot" }
                nav.item(recent_posts_path) { "Recent" }
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
