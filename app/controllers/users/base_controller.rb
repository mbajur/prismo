# frozen_string_literal: true

module Users
  class BaseController < ApplicationController
    # before_action { set_jumpbox_link(find_account) }

    private

    def find_user
      User.find_by!(username: params[:username]).decorate
    end
  end
end
