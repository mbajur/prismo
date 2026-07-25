class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[follow unfollow]

  def follow
    @user = User.find_by!(username: params[:username])
    authorize @user

    Users::Follow.run(follower: current_user, followee: @user)

    redirect_back fallback_location: user_path(@user.username), notice: t(".success")
  end

  def unfollow
    @user = User.find_by!(username: params[:username])
    authorize @user

    Users::Unfollow.run(follower: current_user, followee: @user)

    redirect_back fallback_location: user_path(@user.username), notice: t(".success")
  end
end
