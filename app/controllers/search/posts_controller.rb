module Search
  class PostsController < ApplicationController
    # before_action :set_account_liked_story_ids

    def index
      posts = PostsQuery.new.all
      posts = posts.search(params[:q])

      @pagy, @posts = pagy(posts)
      set_liked_post_ids(@posts)

      render Views::Search::Posts::Index.new(posts: @posts, pagy: @pagy, query: params[:q])
    end
  end
end
