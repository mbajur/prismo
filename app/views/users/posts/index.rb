module Views
  module Users
    module Posts
      class Index < Views::Base
        include Phlex::Rails::Helpers::LinkTo
        include Phlex::Rails::Helpers::ImageTag
        include Phlex::Rails::Helpers::T

        def initialize(posts:, pagy:, user:)
          @posts = posts
          @pagy = pagy
          @user = user
        end

        def view_template(&)
          render Components::Page.new() do
            render Views::Users::Header.new(user: @user)

            render Components::Box.new() do
              render Components::BoxHeader.new() do
                render Components::BoxNav.new() do |nav|
                  nav.item(user_posts_path(@user), active: :exact) { "Hot" }
                  nav.item(recent_user_posts_path(@user)) { "Recent" }
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
