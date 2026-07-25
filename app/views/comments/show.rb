module Views
  module Comments
    class Show < Views::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::T

      def initialize(comment:, children:)
        @comment = comment
        @children = children
      end

      def view_template(&)
        render Components::Page.new() do
          render Components::PageContent.new() do
            render Views::Posts::Item.new(post: @comment.post)
          end

          render Components::Box.new() do
            render Components::BoxContent.new() do
              div(class: "mb-4") do
                p { t(".that_s_only_a") }

                div(class: "flex gap-4") do
                  Link(variant: :secondary, href: post_path(@comment.post)) { t(".see_all_the_comments") }

                  if @comment.parent.present?
                    Link(variant: :secondary, href: post_path(@comment.parent)) { t(".see_parent_comment") }
                  end
                end
              end

              render Views::Comments::Item.new(comment: @comment, children: @children)
            end
          end
        end
      end
    end
  end
end
