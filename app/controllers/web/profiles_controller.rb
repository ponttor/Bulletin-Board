# frozen_string_literal: true

class Web::ProfilesController < ApplicationController
  def show
    @search_query = current_user.bulletins.ransack(params[:search_query])
    @bulletins = @search_query.result
  end
end
