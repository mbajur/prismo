module Views
  module Posts
    class LikeBtn < Views::Base
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::DOMID

      def initialize(post:)
        @post = post
      end

      def view_template(&)
        div(class: "flex items-center gap-[2px] border-1 rounded-full #{'border-orange-400 text-orange-400 bg-orange-50' if upvoted?}", id: dom_id(@post, :like_btn)) do
          button_to(button_url, class: "p-1 cursor-pointer rounded-full #{upvoted? ? 'hover:bg-orange-100' : 'hover:text-orange-400 hover:bg-secondary'}", method: :post, form: { class: "flex" }) do
            Components::Icons::Upvote(class: "w-4 h-4")
          end
          span(class: "pr-3 text-xs font-medium") { @post.likes_count }
        end
      end

      private

      def upvoted?
        (Current.liked_post_ids || []).include?(@post.id)
      end

      def button_url
        if upvoted?
          unlike_post_path(@post)
        else
          like_post_path(@post)
        end
      end
    end
  end
end
