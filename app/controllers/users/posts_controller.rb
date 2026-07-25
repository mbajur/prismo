# frozen_string_literal: true

class Users::PostsController < Users::BaseController
  def index
    @user = find_user
    @feed_title = "Hot posts by #{@user}"
    set_meta_tags @user.to_meta_tags.merge(title: @feed_title)

    posts = PostsQuery.new.hot
    posts = PostsQuery.new(posts).for_user(@user)

    @pagy, @posts = pagy(posts)

    respond_to do |format|
      format.html { render Views::Users::Posts::Index.new(user: @user, posts: @posts, pagy: @pagy) }
      format.atom { render 'posts/index' }
    end
  end

  def recent
    @user = find_user
    @feed_title = "Recent posts by #{@user}"
    set_meta_tags @user.to_meta_tags.merge(title: @feed_title)

    stories = PostsQuery.new.recent
    stories = PostsQuery.new(stories).for_user(@user)

    @pagy, @stories = pagy(stories)

    respond_to do |format|
      format.html { render Views::Users::Posts::Index.new(user: @user, posts: @stories, pagy: @pagy) }
      format.atom { render 'posts/index' }
    end
  end
end
