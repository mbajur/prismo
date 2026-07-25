module Views
  module Comments
    class Edit < Views::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::TurboFrameTag

      def initialize(comment:)
        @comment = comment
      end

      def view_template(&)
        render Components::Page.new() do
          render Components::Box.new() do
            render Components::BoxHeader.new() do
              render Components::BoxTitle.new() { "In reply to" }
            end
            render Components::BoxContent.new() do
              if @comment.parent
                render Views::Comments::Item.new(comment: @comment.parent)
              else
                render Views::Posts::Item.new(post: @comment.post)
              end
            end
          end

          render Components::Box.new() do
            render Components::BoxHeader.new() do
              render Components::BoxTitle.new() { "Edit comment" }
            end
            render Components::BoxContent.new() do
              render Views::Comments::Form.new(comment: @comment)
            end
          end
        end
      end
    end
  end
end
