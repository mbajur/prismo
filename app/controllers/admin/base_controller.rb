# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    private

    def authorize_admin!
      unless current_user.admin?
        redirect_to root_path, alert: 'You are not authorized to access this page.'
      end
    end
  end
end
