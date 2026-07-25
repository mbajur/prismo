# frozen_string_literal: true

class RemovedCommentNull
  attr_accessor :comment, :parent_id

  def initialize(comment = Comment.new)
    @comment = comment
  end

  def kept?
    false
  end

  def user
    User.new
  end

  def body
    "Comment removed"
  end

  def body_html
    "<p>Removed</p>"
  end

  # def decorate
  #   CommentDecorator.new(self)
  # end

  delegate :id,
           :post,
           :post_id,
           :children_count,
           :likes_count,
           :created_at,
           :to_model,
           :discarded?,
           :children,
           :to_model,
           :to_param,
           to: :comment

  class User
    def id
      nil
    end

    def avatar_url(size = :size_60)
      "/placeholders/avatar.jpg"
    end

    def path
      nil
    end

    def decorate
      self
    end

    def username
      "Ghost"
    end

    def to_s
      username
    end

    def username_with_at
      username
    end

    def silenced?
      false
    end

    def suspended?
      false
    end
  end
end
