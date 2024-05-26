# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < Web::Admin::ApplicationController
      def index
        @search_query = Bulletin.ransack(params[:search_query])
        @bulletins = @search_query.result.order(created_at: :desc).page params[:page]
      end

      def reject
        if bulletin.reject!
          redirect_to admin_bulletins_path, flash: { info: t('messages.bulletin_rejected') }
        else
          redirect_to admin_bulletins_path(bulletin), flash: { info: t('messages.bulletin_not_rejected') }
        end
      end

      def archive
        if bulletin.archive!
          redirect_to admin_bulletins_path, flash: { info: t('messages.bulletin_archived') }
        else
          redirect_to admin_bulletins_path(bulletin), flash: { info: t('messages.bulletin_not_archived') }
        end
      end

      def publish
        if bulletin.publish!
          redirect_to admin_bulletins_path, flash: { info: t('messages.bulletin_published') }
        else
          redirect_to admin_bulletins_path(bulletin), flash: { info: t('messages.bulletin_not_published') }
        end
      end

      private

      def bulletin
        Bulletin.find params[:id]
      end
    end
  end
end
