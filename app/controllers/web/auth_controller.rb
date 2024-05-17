# frozen_string_literal: true

class Web::AuthController < ApplicationController
  def callback
    existing_user = User.find_or_create_by(name: auth[:info][:name], email: auth[:info][:email].downcase)
    if existing_user.persisted?
      sign_in existing_user
      flash[:notice] = t('.notice')
      redirect_to root_path
    else
      flash.now[:error] = t('.error')
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
