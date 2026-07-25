module Search
  class CommentsController < ApplicationController
    def index
      comments = CommentsQuery.new.all
      comments = comments.search(params[:q])

      @pagy, @comments = pagy(comments)
      set_liked_comment_ids(@comments)

      render Views::Search::Comments::Index.new(comments: @comments, pagy: @pagy, query: params[:q])
    end
  end
end
