# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    user = find_or_create_user

    if user.persisted?
      successful_sign_in(user)
    else
      failed_sign_in
    end
  end

  private

  def auth
    request.env['omniauth.auth']
  end

  def find_or_create_user
    user = User.find_or_initialize_by(email: auth[:info][:email])

    unless user.persisted?
      user.name = auth[:info][:name]
      user.save
    end

    user
  end

  def successful_sign_in(user)
    sign_in user
    redirect_to root_path, flash: { success: t('.login_success') }
  end

  def failed_sign_in
    redirect_to root_path, flash: { danger: t('.login_error') }
  end
end
