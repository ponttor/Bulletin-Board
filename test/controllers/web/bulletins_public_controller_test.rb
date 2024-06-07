# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsPublicControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:published)
    @attrs = {
      title: Faker::TvShows::TheITCrowd.character,
      description: Faker::TvShows::TheITCrowd.quote,
      category_id: categories(:one).id,
      image: fixture_file_upload('zero.jpg', 'image/jpg')
    }
  end

  test 'get index' do
    get root_url

    assert_response :success

    expected_value = Bulletin.published.count
    assert_select '.bulletin', count: expected_value
  end

  test 'search by title' do
    get root_url, params: { q: { title_cont: 'title1' } }

    assert_response :success

    expected_value = Bulletin.published.where('title LIKE ?', '%title1%').count
    assert_select '.bulletin', count: expected_value
  end

  test 'search by category' do
    category = categories(:one)
    get root_url, params: { q: { category_id_eq: category.id } }

    assert_response :success

    expected_value = Bulletin.published.where(category_id: category.id).count
    assert_select '.bulletin', count: expected_value
  end

  test 'search by title and category' do
    category = categories(:one)
    get root_url, params: { q: { title_cont: 'title2', category_id_eq: category.id } }

    assert_response :success

    expected_value = Bulletin.published.where('title LIKE ?', '%title2%').where(category_id: category.id).count
    assert_select '.bulletin', count: expected_value
  end

  test 'show published bulletin' do
    get bulletin_url(@bulletin)
    assert_response :success

    assert_select 'h2', @bulletin.title
    assert_select 'p', @bulletin.description
  end

  test 'guest cant get new bulletin' do
    get new_bulletin_url

    assert_redirected_to root_url
  end

  test 'not create bulletin if user not logged in' do
    post bulletins_url, params: { bulletin: @attrs
      .merge(image: fixture_file_upload('zero.jpg', 'image/jpg')) }
    assert_redirected_to root_url
  end

  test 'no edit if user not logged in' do
    bulletin_draft = bulletins(:draft)

    get edit_bulletin_url(bulletin_draft)
    assert_redirected_to root_url
  end

  test 'not update if user not logged in' do
    @bulletin = bulletins(:draft)
    patch bulletin_url(@bulletin), params: { bulletin: @attrs }

    @bulletin.reload

    assert_redirected_to root_url
    assert(@bulletin.title != @attrs[:title])
  end

  test 'guest cant archive published' do
    patch archive_bulletin_url(@bulletin)

    @bulletin.reload

    assert_redirected_to root_url
    assert_not(@bulletin.archived?)
  end

  test 'guest cant to_moderate published' do
    patch to_moderate_bulletin_url(@bulletin)

    @bulletin.reload

    assert_redirected_to root_url
    assert_not(@bulletin.under_moderation?)
  end
end
