# frozen_string_literal: true

module AuthConcern
  extend ActiveSupport::Concern

  included do
    private

    def sign_in(user)
      session[:user_id] = user.id
    end

    def sign_out
      session.delete(:user_id)
      session.clear
    end

    def signed_in?
      session[:user_id].present? && current_user.present?
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def admin?
      current_user&.admin?
    end

    def authenticate_user!
      return if signed_in?

      redirect_to root_path, flash: { warning: t('.auth_error') }
    end

    def authenticate_admin!
      return if admin?

      redirect_to root_path, flash: { warning: t('.admin_only') }
    end
  end
end
