class TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tags = Gutentag::Tag.all
    @tags = @tags.search(params[:q]) if params[:q].present?
    @pagy, @tags = pagy(@tags)

    respond_to do |format|
      format.json { render json: @tags.to_json }
    end
  end
end
