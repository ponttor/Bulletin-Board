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
        return unless bulletin.reject!

        redirect_to admin_root_path, flash: { success: t('.success') }
      end

      def archive
        redirect_path = params[:redirect_to] || admin_root_path

        return unless bulletin.archive!

        redirect_to redirect_path, flash: { success: t('.success') }
      end

      def publish
        return unless bulletin.publish!

        redirect_to admin_root_path, flash: { success: t('.success') }
      end

      private

      def bulletin
        Bulletin.find params[:id]
      end
    end
  end
end
