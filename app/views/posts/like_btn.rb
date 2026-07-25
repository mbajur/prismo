module Views
  module Posts
    class LikeBtn < Views::Base
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::DOMID

      def initialize(post:)
        @post = post
      end

      def view_template(&)
        button_to(button_url, class: "text-center block group relative w-full cursor-pointer #{'text-amber-600' if upvoted?}", method: :post, form: { class: "w-full mx-auto", id: dom_id(@post, :like_btn) }) do
          Components::Icons::Upvote(class: "w-4 h-4 absolute left-1/2 -translate-x-1/2 group-hover:-top-px") { }
          span(class: "absolute top-4 left-1/2 -translate-x-1/2") { @post.likes_count }
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
