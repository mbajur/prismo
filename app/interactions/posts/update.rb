# frozen_string_literal: true

module Posts
  class Update < Posts::CreateUpdateBase
    object :post, class: Post

    validates :url, url: { allow_blank: true }
    validate :url_or_description_required
    validate :title_update_time_limit

    def execute
      post.title = title if title
      post.tag_names = tags if tag_list
      post.description = description if description
      post.url = url if url.present? && can_update_url?

      post.modified_at = Time.current
      post.modified_count += 1 if edit_grace_period_passed?

      if post.save
        after_post_save_hook(post)
      else
        errors.merge!(post.errors)
      end

      post
    end

    def persisted?
      true
    end

    private

    def after_post_save_hook(post)
      post.cache_description
      # Stories::ScrapJob.perform_later(post.id) if post.url_changed?
      # Stories::BroadcastChanges.run!(story: post)
      # ActivityPub::UpdateDistributionJob.call_later(post) if post.local?
    end

    def title_update_time_limit
      return unless title_changed?

      limit = Setting.post_title_update_time_limit
      errors.add(:title, "can't be edited after #{limit} minutes") unless can_update_title?
    end

    def title_changed?
      title && title != post.title
    end

    def can_update_title?
      PostPolicy.new(user, post).update_title?
    end

    def can_update_url?
      Posts::UpdatePolicy.new(user, post).update_url?
    end

    def edit_grace_period_passed?
      period = Setting.edit_counter_grace_period_minutes
      period.to_i.minutes.ago > post.created_at
    end
  end
end
