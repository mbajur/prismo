module Views
  module Comments
    class New < Views::Base
      include Phlex::Rails::Helpers::LinkTo

      def initialize(comment:, post:, parent: nil)
        @comment = comment
        @post = post
        @parent = parent
      end

      def view_template(&)
        render Components::Page.new() do
          render Components::Box.new() do
            render Components::BoxHeader.new() do
              render Components::BoxTitle.new() { "In reply to" }
            end
            render Components::BoxContent.new() do
              render Views::Comments::Item.new(comment: @parent)
            end
          end

          render Components::Box.new() do
            render Components::BoxHeader.new() do
              render Components::BoxTitle.new() { "Your reply" }
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
