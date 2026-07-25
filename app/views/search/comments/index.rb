module Views
  module Search
    module Comments
      class Index < Views::Base
        include Phlex::Rails::Helpers::LinkTo

        def initialize(comments:, pagy:, query:)
          @comments = comments
          @pagy = pagy
          @query = query
        end

        def view_template(&)
          render Components::Page.new(content_shifted: true) do
            render Components::Box.new() do
              render Components::BoxHeader.new() do
                render Components::BoxNav.new() do |nav|
                  nav.item(search_posts_path(q: @query), active: :exact) { "Posts" }
                  nav.item(search_comments_path(q: @query)) { "Comments" }
                end
              end

              render Components::BoxContent.new() do
                render Views::Comments::List.new(comments: @comments)
              end
            end
          end
        end
      end
    end
  end
end
