# frozen_string_literal: true

class Users::CommentsController < Users::BaseController
  def index
    @user = find_user
    @page_title = "Comments by #{@user}"
    comments = CommentsQuery.new.all
    comments = CommentsQuery.new(comments).by_user(@user)

    @pagy, @comments = pagy(comments)

    render Views::Users::Comments::Index.new(user: @user, comments: @comments, pagy: @pagy)
  end

  def recent
    @user = find_user
    @page_title = "Recent comments by #{@user}"
    comments = CommentsQuery.new.recent
    comments = CommentsQuery.new(comments).by_user(@user)

    @pagy, @comments = pagy(comments)

    render Views::Users::Comments::Index.new(user: @user, comments: @comments, pagy: @pagy)
  end
end
