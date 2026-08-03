module Views
  module Comments
    class ItemMetaSecondary < Base
      include Phlex::Rails::Helpers::Pluralize
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::ButtonTo

      def initialize(comment:)
        @comment = comment
      end

      def view_template(&)
        div(id: dom_id(@comment, :meta_secondary), class: "flex items-center gap-2 text-sm text-gray-500") do
          div(class: "") do
            render Views::Comments::LikeBtn.new(comment: @comment)
            span { " / " }
            span { pluralize(@comment.children_count, "reply") }
          end

          a(href: post_path(@comment.post, anchor: dom_id(@comment))) { "link" }
          a(href: post_path(@comment.post, anchor: dom_id(@comment.parent))) { "parent" } if @comment.parent_id
          a(href: new_post_comment_comment_path(@comment.post, @comment)) { "reply" } if show_reply?

          if show_more?
            DropdownMenu do
              DropdownMenuTrigger do
                a(class: "cursor-pointer") { "more" }
              end
              DropdownMenuContent do
                DropdownMenuLabel { "More options" }
                DropdownMenuSeparator
                DropdownMenuItem(href: edit_comment_path(@comment)) { "Edit comment" } if policy.edit?
                # DropdownMenuItem(href: "#") { "Flag" }
                DropdownMenuItem(href: comment_path(@comment), data: { turbo_method: :delete, turbo_confirm: "Are you sure?" }) { "Delete" } if policy.destroy?
              end
            end
          end
        end
      end

      private

      def policy
        CommentPolicy.new(current_user, @comment)
      end

      def show_more?
        user_signed_in? && @comment.kept?
      end

      def show_reply?
        @comment.kept?
      end
    end
  end
end
