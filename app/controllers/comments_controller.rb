# frozen_string_literal: true

class CommentsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!, only: %i[new create edit update like unlike destroy]

  # before_action { set_jumpbox_link(Jumpbox::COMMENTS_LINK) }

  def index
    comments = CommentsQuery.new.hot.kept
    comments = CommentsQuery.new(comments).with_story
    @pagy, @comments = pagy(comments)
    set_liked_comment_ids(@comments)

    render Views::Comments::Index.new(comments: @comments, pagy: @pagy)
  end

  def recent
    comments = CommentsQuery.new.recent.kept
    comments = CommentsQuery.new(comments).with_story
    @pagy, @comments = pagy(comments)
    set_liked_comment_ids(@comments)

    render Views::Comments::Index.new(comments: @comments, pagy: @pagy)
  end

  def edit
    # set_account_liked_story_ids

    comment = find_comment
    # @comment = comment.removed? ? RemovedCommentNull.new(comment) : comment
    @comment = comment

    render Views::Comments::Edit.new(comment: @comment)
  end

  def update
    @comment = find_comment

    if @comment.update(comment_params)
      redirect_to comment_path(@comment), notice: "Comment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @post = find_post
    @parent = Comment.find_by(id: params[:comment_id]) if params[:comment_id].present?
    @comment = Comment.new(post: @post, parent: @parent)

    render Views::Comments::New.new(comment: @comment, post: @post, parent: @parent)
  end

  def create
    @post = find_post
    @parent = Comment.find_by(id: params[:comment_id]) if params[:comment_id].present?
    @comment = Comment.new(comment_params.merge(post: @post, parent: @parent, user: current_user))

    if @comment.save
      @comment.cache_body
      Comments::Like.run!(comment: @comment, user: current_user)

      redirect_to post_path(@post, anchor: dom_id(@comment)), notice: "Comment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def like
    @comment = find_comment
    Current.liked_comment_ids = [ @comment.id ]
    authorize @comment

    @outcome = Comments::Like.run(comment: @comment, user: current_user)
  end

  def unlike
    @comment = find_comment
    Current.liked_comment_ids = []
    authorize @comment

    @outcome = Comments::Unlike.run(comment: @comment, user: current_user)
    @comment.reload
  end

  def destroy
    @comment = find_comment
    authorize @comment

    # Comments::DeleteJob.perform_later(comment.id)
    Comments::Delete.run(comment: @comment, user: current_user)
  end

  private

  def find_comment
    Comment.find(params[:id])
  end

  def find_post
    Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
