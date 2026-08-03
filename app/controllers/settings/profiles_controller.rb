# frozen_string_literal: true

class Settings::ProfilesController < ApplicationController
  before_action :authenticate_user!

  # layout 'settings'

  def show
    @user = current_user
    @destroy = Users::Delete.new

    render Views::Settings::Profiles::Show.new(user: @user)
  end

  def update
    @user = current_user

    if @user.update(user_params)
      # ActivityPub::UpdateDistributionJob.call_later(@user)
      redirect_to settings_profile_path, notice: I18n.t("generic.changes_saved_msg")
    else
      render Views::Settings::Profiles::Show.new(user: @user)
    end
  end

  def destroy
    outcome = Accounts::Delete.run(
      account: current_user.account,
      current_password: params[:accounts_delete][:current_password]
    )

    if outcome.valid?
      sign_out current_user
      flash[:success] = t("accounts.destroy.success")
      redirect_to :root
    else
      flash[:alert] = outcome.errors.full_messages.to_sentence
      redirect_to settings_profile_path
    end
  end

  private

  def user_params
    # params.require(:account).permit(:display_name, :bio, :avatar, :remove_avatar, :theme)
    params.require(:user).permit(:display_name, :bio, :avatar, :remove_avatar, :theme)
  end
end
