# frozen_string_literal: true

class PostsQuery
  attr_reader :relation

  def initialize(relation = Post.all)
    @relation = relation
  end

  def with_includes
    relation.includes(:fedipub_actor, :url_meta, :tags, :taggings, group: [ :fedipub_actor ])
  end

  def all
    with_includes
  end

  def hot
    with_includes
      .order(Arel.sql("ranking(posts.likes_count, posts.created_at, 3) DESC"))
      .where("posts.created_at > ?", Post::HOT_DAYS_LIMIT.days.ago)
  end

  def recent
    with_includes.order(created_at: :desc)
  end

  def for_user(user)
    with_includes.where(user_id: user.id)
  end

  def tagged_with(tags)
    with_includes.tagged_with(names: tags)
  end

  def by_followed_accounts(account)
    following_ids_sql = "SELECT following_id FROM follows WHERE follower_id = :account_id AND follower_type = 'Account'"
    with_includes.where("account_id IN (#{following_ids_sql})", account_id: account.id)
  end

  def for_dashboard(account)
    following_account_ids_sql = "SELECT following_id FROM follows WHERE follower_id = :account_id AND follower_type = 'Account'"
    following_tag_ids_sql = "SELECT following_id FROM follows WHERE follower_id = :account_id AND following_type = 'Gutentag::Tag'"
    tagged_with_query_sql = "SELECT gutentag_taggings.taggable_id FROM gutentag_taggings WHERE gutentag_taggings.taggable_type = 'ActivityPubObject' AND gutentag_taggings.tag_id IN (#{following_tag_ids_sql})"

    with_includes
      .where(
        "account_id IN (#{following_account_ids_sql}) OR (activitypub_objects.id IN (#{tagged_with_query_sql}) AND activitypub_objects.type = :object_type)",
        account_id: account.id,
        object_type: ActivityPubPost.name
      )
  end

  def without_silenced
    with_includes.where(accounts: { silenced: false })
  end
end
