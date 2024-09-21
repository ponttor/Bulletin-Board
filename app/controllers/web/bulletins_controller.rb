# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update archive to_moderate]

  def index
    @search_query = Bulletin.published.ransack(params[:q])
    @bulletins = @search_query.result
                              .order(created_at: :desc)
                              .page(params[:page])
  end

  def show
    @bulletin = current_bulletin
    authorize @bulletin
  end

  def new
    @bulletin = current_user.bulletins.new
  end

  def edit
    @bulletin = current_bulletin
    authorize @bulletin
  end

  def create
    @bulletin = current_user.bulletins.build(bulletin_params)

    if @bulletin.save
      redirect_to profile_path, flash: { success: t('.success') }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @bulletin = current_bulletin
    authorize @bulletin

    if @bulletin.update(bulletin_params)
      redirect_to profile_path, flash: { success: t('.success') }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def to_moderate
    authorize current_bulletin

    handle_bulletin_event(:to_moderate)
  end

  def archive
    authorize current_bulletin

    handle_bulletin_event(:archive)
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :category_id, :image)
  end

  def current_bulletin
    Bulletin.find params[:id]
  end

  def handle_bulletin_event(event)
    current_bulletin.send("#{event}!")
    flash[:success] = t('.success')
    redirect_to profile_path
  rescue StandardError
    flash[:error] = t('.error')
  end
end
