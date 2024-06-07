# frozen_string_literal: true

module Web
  module Admin
    class HomeController < Web::Admin::ApplicationController
      def index
        @bulletins = Bulletin.where(state: 'under_moderation').order(created_at: :desc).page(params[:page]).per(params[:per_page])
      end
    end
  end
end
