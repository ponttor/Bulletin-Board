# frozen_string_literal: true

class Web::BulletinsController < ApplicationController
  before_action :set_bulletin, only: %i[show edit update to_moderate archive]
  before_action :authorize_bulletin!
  before_action :authenticate_user!, only: %i[new create edit update archive to_moderate]
  after_action :verify_authorized

  def index
    @search_query = Bulletin.published.ransack(params[:q])
    @bulletins = @search_query.result.page(params[:page]).per(params[:per_page])
  end

  def show; end

  def new
    @bulletin = current_user.bulletins.new
  end

  def edit; end

  def create
    Rails.logger.debug params
    @bulletin = current_user.bulletins.build(bulletin_params)

    if @bulletin.save
      redirect_to profile_path, flash: { success: t('.success') }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @bulletin = current_bulletin

    if @bulletin.update(bulletin_params)
      redirect_to profile_path, flash: { success: t('.success') }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def to_moderate
    if @bulletin.to_moderate!
      flash[:success] = t('.success')
      redirect_to profile_path, flash: { success: t('.success') }
    else
      flash.now[:error] = t('.error')
      render :show
    end
  end

  def archive
    if @bulletin.archive!
      flash[:success] = t('.success')
      redirect_to profile_path
    else
      flash.now[:error] = t('.error')
      render :show
    end
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :bulletin_id, :category_id, :image)
  end

  def current_bulletin
    Bulletin.find params[:id]
  end

  def set_bulletin
    @bulletin = Bulletin.find(params[:id])
  end

  def authorize_bulletin!
    authorize(@bulletin || Bulletin)
  end
end
