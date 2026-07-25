module Views
  module Posts
    class Show < Views::Base
      include Phlex::Rails::Helpers::LinkTo

      def initialize(post:, comments:)
        @post = post
        @comments = comments
      end

      def view_template(&)
        render Components::Page.new(content_shifted: true) do
          render Components::Box.new() do
            render Components::BoxContent.new() do
              render Views::Posts::Item.new(post: @post)

              if @post.description_cached.present?
                hr(class: "my-4")
                div(class: "prose max-w-full") do
                  raw @post.description_cached.html_safe
                end
              end
            end
          end

          render Components::Box.new() do
            render Components::BoxHeader.new() do
              render Components::BoxTitle.new() { "Comments" }
            end

            render Components::BoxContent.new() do
              render Views::Comments::Form.new(comment: Comment.new(post: @post))
            end

            render Components::BoxContent.new() do
              ul(class: "flex flex-col gap-4") do
                @comments.each do |comment, children|
                  render Views::Comments::Item.new(comment: comment, children: children)
                end
              end
            end
          end
        end
      end
    end
  end
end
