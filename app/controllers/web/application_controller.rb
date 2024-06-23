# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include Pundit::Authorization
  include AuthConcern

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_to root_path, flash: { warning: t('auth_error') }
  end
end
