# frozen_string_literal: true

module Web
  module Admin
    class CategoriesController < Web::Admin::ApplicationController
      def index
        @categories = Category.all.page(params[:page])
      end

      def new
        @category = Category.new
      end

      def edit
        @category = Category.find(params[:id])
      end

      def create
        @category = Category.new(category_params)
        if @category.save
          redirect_to admin_categories_path, method: :get, flash: { success: t('.success') }
        else
          render :new, status: :unprocessable_entity
        end
      end

      def update
        @category = Category.find(params[:id])

        if @category.update(category_params)
          redirect_to admin_categories_path, flash: { success: t('.success') }
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @category = Category.find(params[:id])
        if @category.bulletins.present?
          redirect_to admin_categories_path, flash: { warning: t('.contains_bulletins') }
        else
          @category.destroy
          redirect_to admin_categories_path, flash: { success: t('.success') }
        end
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
