# frozen_string_literal: true

module Admin
  class FlagsController < ApplicationController
    def index
      authorize Flag
      @pagy, @flags = pagy(Flag.order(created_at: :desc))

      render Views::Admin::Flags::Index.new(flags: @flags, pagy: @pagy)
    end

    def show
      @flag = find_flag
      authorize @flag

      render Views::Admin::Flags::Show.new(flag: @flag)
    end

    def resolve
      @flag = find_flag
      authorize @flag

      Flags::Resolve.run(flag: @flag.object)

      redirect_to admin_flag_path(@flag), notice: 'Flag marked as resolved'
    end

    def unresolve
      @flag = find_flag
      authorize @flag

      Flags::Unresolve.run(flag: @flag.object)

      redirect_to admin_flag_path(@flag), notice: 'Flag marked as unresolved'
    end

    private

    def find_flag
      @find_flag ||= Flag.find(params[:id]).decorate
    end
  end
end
