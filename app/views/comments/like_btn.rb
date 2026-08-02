module Views
  module Comments
    class LikeBtn < Base
      include Phlex::Rails::Helpers::Pluralize
      include Phlex::Rails::Helpers::ButtonTo

      def initialize(comment:)
        @comment = comment
      end

      def view_template(&)
        button_to(button_url, class: "cursor-pointer #{'font-bold text-amber-600' if upvoted?}",
                              method: :post,
                              form: { class: "inline" }
        ) do
          pluralize(@comment.likes_count, "like")
        end
      end

      private

      def upvoted?
        (Current.liked_comment_ids || []).include?(@comment.id)
      end

      def button_url
        if upvoted?
          unlike_comment_path(@comment)
        else
          like_comment_path(@comment)
        end
      end
    end
  end
end
