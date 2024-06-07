# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < Web::Admin::ApplicationController
      def index
        @search_query = Bulletin.ransack(params[:q])
        @bulletins = @search_query.result.order(created_at: :desc).page(params[:page]).per(params[:per_page])
      end

      def reject
        if bulletin.reject!
          redirect_to admin_root_path, flash: { success: t('.success') }
        else
          redirect_to admin_root_path, flash: { danger: t('.error') }
        end
      end

      def archive
        redirect_path = params[:redirect_to] || admin_root_path

        if bulletin.archive!
          redirect_to redirect_path, flash: { success: t('.success') }
        else
          redirect_to redirect_path, flash: { danger: t('.error') }
        end
      end

      def publish
        if bulletin.publish!
          redirect_to admin_root_path, flash: { success: t('.success') }
        else
          redirect_to admin_root_path, flash: { danger: t('.error') }
        end
      end

      private

      def bulletin
        Bulletin.find params[:id]
      end
    end
  end
end
