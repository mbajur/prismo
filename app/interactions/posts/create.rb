# frozen_string_literal: true

module Posts
  class Create < Posts::CreateUpdateBase
    validates :url, url: { allow_blank: true }
    validate :url_or_description_required

    def execute
      post = Post.new(inputs)
      post.user = user

      post.url_domain = URI.parse(url).host if url.present?
      post.group = Group.find_by!(supergroup: true)
      post.tag_names = tags

      if post.save
        after_post_save_hook(post)
      else
        errors.merge!(post.errors)
      end

      post
    end

    private

    def after_post_save_hook(post)
      user.touch(:last_active_at)
      post.cache_description

      Posts::Like.run!(post: post, user: user)
      Posts::ScrapJob.perform_later(post)
      Posts::SendWebmentionJob.perform_later(post) if send_webmention?(post)
    end

    def send_webmention?(post)
      post.link? && post.local_fedipub_entity? && Setting.webmentions_enabled
    end
  end
end
