# frozen_string_literal: true

class Web::BulletinsController < ApplicationController
  def index
    @bulletins = Bulletin.all
  end

  def show
    @bulletin = current_bulletin
  end

  def new
    @bulletin = current_user.bulletins.build
  end

  def edit
    @bulletin = current_bulletin

    return unless @bulletin.draft? && current_user != @bulletin.user

    redirect_to root_path, notice: t('only_for_authors')
  end

  def create
    @bulletin = current_user.bulletins.build(bulletin_params)

    if @bulletin.save
      redirect_to profile_path, flash: { info: t('messages.bulletin_created') }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @bulletin = current_bulletin

    if @bulletin.update(bulletin_params)
      redirect_to profile_path, flash: { info: t('messages.bulletin_updated') }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def archive
    @bulletin = current_bulletin
    @bulletin.archive!

    redirect_to profile_path, flash: { info: t('messages.bulletin_archived') }
  end

  def moderate
    @bulletin = current_bulletin
    @bulletin.moderate!

    redirect_to profile_path, flash: { info: t('messages.bulletin_moderated') }
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :bulletin_id, :category_id, :image)
  end

  def current_bulletin
    Bulletin.find params[:id]
  end
end
