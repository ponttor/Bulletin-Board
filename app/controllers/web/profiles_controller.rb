# frozen_string_literal: true

class Web::ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @search_query = current_user.bulletins.ransack(params[:q])
    @bulletins = @search_query.result.page(params[:page])
  end
end
