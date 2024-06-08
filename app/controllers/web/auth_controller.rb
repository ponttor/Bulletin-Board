# frozen_string_literal: true

class Web::AuthController < ApplicationController
  def callback
    existing_user = User.find_or_create_by(name: auth[:info][:name], email: auth[:info][:email])
    if existing_user.persisted?
      sign_in existing_user
      redirect_to root_path, flash: { success: t('.login_success') }
    else
      redirect_to root_path, flash: { danger: t('.login_error') }
    end
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
