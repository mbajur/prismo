class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update like unlike]
  before_action :ensure_short_id_used, only: [ :show ]

  def index
    @page_title = "Hot stories"
    @feed_title = @page_title
    set_meta_tags alternate: [ {
      href: posts_path(format: :atom),
      type: "application/atom+xml"
    } ]

    posts = PostsQuery.new.hot
    # posts = PostsQuery.new(posts).without_silenced

    @pagy, @posts = pagy(posts)
    set_liked_post_ids(@posts)

    respond_to do |format|
      format.html { render Views::Posts::Index.new(posts: @posts, pagy: @pagy) }
      format.atom { render :index }
    end
  end

  def recent
    @page_title = "Recent stories"
    @feed_title = @page_title
    set_meta_tags alternate: [ {
      href: recent_posts_path(format: :atom),
      type: "application/atom+xml"
    } ]

    posts = PostsQuery.new.recent
    # posts = PostsQuery.new(posts).without_silenced

    @pagy, @posts = pagy(posts)
    set_liked_post_ids(@posts)

    respond_to do |format|
      format.html { render Views::Posts::Index.new(posts: @posts, pagy: @pagy) }
      format.atom { render :index }
    end
  end

  def show
    @post = find_post
    set_meta_tags @post

    # We're doing that to avoid rendering the full post template for Mastodon
    # link preview requests.
    if mastodon_request?
      respond_to do |format|
        format.html { render(partial: "shared/meta_tags", layout: false) }
        format.activitypub { render json: @post.to_activitypub_object }
      end
    else
      @comments = @post.comments.includes(:fedipub_actor, :parent).hash_tree
      set_liked_post_ids(Post.where(id: @post.id))
      set_liked_comment_ids(@post.comments)

      @comment = Comment.new

      respond_to do |format|
        format.html { render Views::Posts::Show.new(post: @post, comments: @comments) }
        format.activitypub { render json: @post.to_activitypub_object }
      end
    end
  end

  def new
    @post = Posts::Create.new(*new_post_params)
    authorize @post

    render Views::Posts::New.new(post: @post)
  end

  def create
    authorize Posts::Create

    outcome = Posts::Create.run(
      title: params.fetch(:post)[:title],
      url: params.fetch(:post)[:url],
      description: params.fetch(:post)[:description],
      tag_list: params.fetch(:post)[:tag_list],
      user: current_user
    )

    if outcome.valid?
      path = outcome.result.decorate.path
      redirect_to path, notice: "Post has been created"
    else
      @post = outcome
      render Views::Posts::New.new(post: @post), status: :unprocessable_entity
    end
  end

  def edit
    post = find_post
    authorize post

    post = Posts::Update.new(
      post: post,
      url: post.url,
      title: post.title,
      tag_list: post.tag_names.join(", "),
      description: post.description,
    )

    render Views::Posts::Edit.new(post: post)
  end

  def update
    post = find_post
    authorize post

    outcome = Posts::Update.run(
      post: post.object,
      url: params.fetch(:post)[:url],
      title: params.fetch(:post)[:title],
      tag_list: params.fetch(:post)[:tag_list],
      description: params.fetch(:post)[:description],
      user: current_user
    )

    if outcome.valid?
      path = outcome.result.decorate.path
      redirect_to path, notice: "Post has been updated"
    else
      post = outcome
      render Views::Posts::Edit.new(post: post), status: :unprocessable_entity
    end
  end

  def like
    @post = find_post
    Current.liked_post_ids = [ @post.id ]
    authorize @post

    @outcome = Posts::Like.run(post: @post, user: current_user)
  end

  def unlike
    @post = find_post
    Current.liked_post_ids = []
    authorize @post

    @outcome = Posts::Unlike.run(post: @post, user: current_user)
    @post.reload
  end

  def scrap_url
    cache_key = Digest::MD5.hexdigest params[:url]

    scrapper = Rails.cache.fetch("link_thumbnailer/#{cache_key}", expires_in: 1.hour) do
      LinkThumbnailer.generate(params[:url])
    end

    render json: scrapper
  rescue LinkThumbnailer::BadUriFormat => _e
    render json: { errors: [ "URL seems to be invalid" ] }, status: :bad_request
  rescue LinkThumbnailer::HTTPError => _e
    render json: { errors: [ "URL seems to be invalid" ] }, status: :bad_request
  end

  private

  def new_post_params
    params.permit(:url, :title, :description, :tag_list)
  end

  def find_post
    Post.find_by_short_id_or_id!(params[:id]).decorate
  end

  # This is gonna be removed at some point. It's here only because
  # we changed the URL format to use short IDs instead of IDs and we
  # need to redirect old URLs to the new format for some time.
  def ensure_short_id_used
    @post = find_post
    redirect_to post_path(@post) if params[:id] != @post.to_param
  end
end
