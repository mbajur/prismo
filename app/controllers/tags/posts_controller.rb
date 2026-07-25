module Tags
  class PostsController < ApplicationController
    def index
      @tag = find_tag
      posts = PostsQuery.new.hot
      posts = PostsQuery.new(posts).tagged_with([ @tag.name ])

      @feed_title = "Hot posts in #{@tag.decorate}"
      set_meta_tags @tag.decorate.to_meta_tags.merge(title: @feed_title)

      @pagy, @posts = pagy(posts)

      respond_to do |format|
        format.html { render Views::Tags::Posts::Index.new(tag: @tag, posts: @posts, pagy: @pagy) }
        format.atom { render "posts/index" }
      end
    end

    def recent
      @tag = find_tag
      posts = PostsQuery.new.recent
      posts = PostsQuery.new(posts).tagged_with([ @tag.name ])

      @feed_title = "Recent posts in #{@tag.decorate}"
      set_meta_tags @tag.decorate.to_meta_tags.merge(title: @feed_title)

      @pagy, @posts = pagy(posts)

      respond_to do |format|
        format.html { render Views::Tags::Posts::Index.new(tag: @tag, posts: @posts, pagy: @pagy) }
        format.atom { render "posts/index" }
      end
    end

    private

    def find_tag
      @find_tag ||= Gutentag::Tag.find_by!(name: params[:tag_name]).decorate
    end
  end
end
