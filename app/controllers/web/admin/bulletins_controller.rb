# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < Web::Admin::ApplicationController
      def index
        @search_query = Bulletin.ransack(params[:search_query])
        @bulletins = @search_query.result.order(created_at: :desc).page params[:page]
      end

      def reject
        if current_bulletin.may_reject?
          current_bulletin.reject!
          redirect_to admin_bulletins_path, flash: { info: t('messages.bulletin_rejected') }
        else
          redirect_to bulletins_path(current_bulletin), flash: { info: t('messages.bulletin_not_rejected') }
        end
      end

      def archive
        if current_bulletin.may_archive?
          current_bulletin.archive!
          redirect_to admin_bulletins_path, flash: { info: t('messages.bulletin_archived') }
        else
          redirect_to bulletins_path(current_bulletin), flash: { info: t('messages.bulletin_not_archived') }
        end
      end

      def publish
        if current_bulletin.may_archive?
          current_bulletin.publish!
          redirect_to admin_bulletins_path, flash: { info: t('messages.bulletin_published') }
        else
          redirect_to bulletins_path(current_bulletin), flash: { info: t('messages.bulletin_not_published') }
        end
      end

      private

      def current_bulletin
        Bulletin.find params[:id]
      end
    end
  end
end
