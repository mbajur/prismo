module Views
  module Comments
    class Index < Base
      def initialize(comments:, pagy:)
        @comments = comments
        @pagy = pagy
      end

      def view_template(&)
        render Components::Page.new(content_shifted: true) do
          render Components::Box.new() do
            render Components::BoxHeader.new() do
              render Components::BoxNav.new() do |nav|
                nav.item(comments_path, active: :exact) { "Hot" }
                nav.item(recent_comments_path) { "Recent" }
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
