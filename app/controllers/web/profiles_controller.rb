# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  def show
    authenticate_user!

    @search_query = current_user&.bulletins&.ransack(params[:q])
    @bulletins = @search_query&.result&.order(created_at: :desc)&.page(params[:page])
  end
end
