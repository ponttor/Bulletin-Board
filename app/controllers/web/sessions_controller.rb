# frozen_string_literal: true

class Web::SessionsController < Web::ApplicationController
  def destroy
    session[:user_id] = nil
    redirect_to root_path, flash: { success: t('.bye') }
  end
end
