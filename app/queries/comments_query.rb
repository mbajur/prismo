# frozen_string_literal: true

class CommentsQuery
  attr_reader :relation

  def initialize(relation = Comment.all)
    @relation = relation
  end

  def with_includes
    relation.includes(:parent, :user, :post)
  end

  def with_story
    relation.includes(:post)
  end

  def all
    with_includes
  end

  def hot
    with_includes.order(Arel.sql("ranking(comments.likes_count, comments.created_at, 3) DESC"))
                 .where("comments.created_at > ?", Comment::HOT_DAYS_LIMIT.days.ago)
  end

  def recent
    with_includes.order(created_at: :desc)
  end

  def by_user(user)
    with_includes.where(user_id: user.id)
  end
end
