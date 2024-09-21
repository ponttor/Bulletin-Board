# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < Web::Admin::ApplicationController
      def index
        @search_query = Bulletin.ransack(params[:q])
        @bulletins = @search_query.result
                                  .order(created_at: :desc)
                                  .page(params[:page])
      end

      def reject
        handle_bulletin_event(:reject)
      end

      def archive
        handle_bulletin_event(:archive)
      end

      def publish
        handle_bulletin_event(:publish)
      end

      private

      def bulletin
        Bulletin.find params[:id]
      end

      def handle_bulletin_event(event)
        bulletin.send("#{event}!")
        flash[:success] = t('.success')
        redirect_to admin_root_path
      rescue StandardError
        flash[:error] = t('.error')
      end
    end
  end
end
