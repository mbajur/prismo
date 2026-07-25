class ApplicationController < ActionController::Base
  include Pagy::Method
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def set_liked_post_ids(posts)
    return unless user_signed_in?

    Current.liked_post_ids = current_user.likes
                                         .where(likeable_type: "Post", likeable_id: posts.ids)
                                         .pluck(:likeable_id)
  end

  def set_liked_comment_ids(comments)
    return unless user_signed_in?

    Current.liked_comment_ids = current_user.likes
                                            .where(likeable_type: "Comment", likeable_id: comments.ids)
                                            .pluck(:likeable_id)
  end
end
