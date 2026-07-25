module Views
  module Comments
    class Item < Base
      include Phlex::Rails::Helpers::Pluralize
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::SimpleFormat
      include Phlex::Rails::Helpers::LinkTo

      def initialize(comment:, children: Comment.none)
        @comment = comment.discarded? ? RemovedCommentNull.new(comment) : comment
        @user = @comment.user.decorate
        @children = children
      end

      def view_template(&)
        li(class: "pl-2 flex flex-col gap-2 pb-2", id: dom_id(@comment)) do
          div(class: "flex items-center gap-2 text-sm") do
            img(src: @comment.user.avatar_url, class: "w-4 h-4 rounded-full")
            span(class: "underline") { link_to(@user, @user.path) }
            span(class: "text-gray-500") { timeago(@comment.created_at) }
          end

          div(class: body_classes) { simple_format @comment.body }

          render Views::Comments::ItemMetaSecondary.new(comment: @comment)

          if @children.any?
            ul(class: "border-l-3 border-b pl-2 flex flex-col gap-4 mt-2 pb-2") do
              @children.each do |child_comment, child_children|
                render Views::Comments::Item.new(comment: child_comment, children: child_children)
              end
            end
          end
        end
      end

      private

      def body_classes
        classes = "text-sm [&_p]:mb-2 [&_p:last-child]:mb-0"
        classes += " text-muted-foreground" if @comment.discarded?
        classes
      end
    end
  end
end
