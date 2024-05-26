# frozen_string_literal: true

require 'test_helper'

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    sign_in(@admin)
    @category = categories(:one)
    @attrs = {
      name: Faker::TvShows::BigBangTheory.character
    }
  end

  test 'index' do
    get admin_categories_url
    assert_response :success
  end

  test 'new' do
    get new_admin_category_url
    assert_response :success
  end

  test 'create' do
    post admin_categories_url, params: { category: @attrs }
    assert_redirected_to admin_categories_url
    category = Category.find_by @attrs
    assert(category.present?)
  end

  test 'edit' do
    get edit_admin_category_url(@category)
    assert_response :success
  end

  test 'update' do
    patch admin_category_url(@category), params: { category: @attrs }
    @category.reload
    category = Category.find_by @attrs
    assert(@attrs[:name], @category.name)
    assert(category.present?)
  end

  test 'destroy' do
    delete admin_category_path(@category)
    assert_redirected_to admin_categories_url
    assert_nil Category.find_by @attrs
  end
end
