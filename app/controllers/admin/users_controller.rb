# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    def index
      authorize User

      @pagy, @users = pagy(User.all)

      render Views::Admin::Users::Index.new(users: @users, pagy: @pagy)
    end

    def show
      @user = find_user
      authorize @user

      render Views::Admin::Users::Show.new(user: @user)
    end

    def suspend
      @user = find_user
      authorize @user

      Users::SuspendJob.perform_later(@user)

      redirect_back(
        fallback_location: admin_users_path,
        notice: 'User scheduled for suspension'
      )
    end

    def silence
      @user = find_user
      authorize @user

      @user.update(silenced: true)

      redirect_back(
        fallback_location: admin_users_path,
        notice: 'User silenced'
      )
    end

    def unsilence
      @user = find_user
      authorize @user

      @user.update(silenced: false)

      redirect_back(
        fallback_location: admin_users_path,
        notice: 'User unsilenced'
      )
    end

    private

    def find_user
      User.find(params[:id])
    end
  end
end
