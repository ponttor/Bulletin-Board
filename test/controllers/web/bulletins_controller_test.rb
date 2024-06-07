# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
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
    sign_in(@user)
    get bulletin_url(@bulletin)
    assert_response :success

    assert_select 'h2', @bulletin.title
    assert_select 'p', @bulletin.description
  end

  test 'show draft bulletin to author' do
    sign_in(@user)
    bulletin_draft = bulletins(:draft)
    get bulletin_url(bulletin_draft)

    assert_response :success

    assert_select 'h2', bulletin_draft.title
    assert_select 'p', bulletin_draft.description
  end

  test 'do not show draft bulletin to not author' do
    user = users(:second)
    sign_in(user)
    bulletin_draft = bulletins(:draft)

    get bulletin_url(bulletin_draft)

    assert_redirected_to root_path
  end

  test 'new bulletin' do
    sign_in(@user)
    get new_bulletin_url

    assert_response :success
  end

  test 'guest cant get new bulletin' do
    get new_bulletin_url

    assert_redirected_to root_url
  end

  test 'create bulletin' do
    sign_in(@user)
    post bulletins_url, params: { bulletin: @attrs }
    bulletin = Bulletin.find_by(@attrs.except(:image))

    assert_redirected_to(bulletin_url(bulletin))
    assert(bulletin.present?)
    assert_equal(bulletin.title, @attrs[:title])
    assert_equal(bulletin.description, @attrs[:description])
    assert_equal(bulletin.category_id, @attrs[:category_id])
  end

  test 'not create bulletin if user not logged in' do
    post bulletins_url, params: { bulletin: @attrs
      .merge(image: fixture_file_upload('zero.jpg', 'image/jpg')) }
    assert_redirected_to root_url
  end

  test 'not create without title' do
    sign_in(@user)

    @attrs[:title] = nil
    post bulletins_url, params: { bulletin: @attrs
      .merge(image: fixture_file_upload('zero.jpg', 'image/jpg')) }
    assert_response :unprocessable_entity
  end

  test 'edit bulletin' do
    sign_in(@user)
    bulletin_draft = bulletins(:draft)
    get edit_bulletin_url(bulletin_draft)
    assert_response :success
  end

  test 'no edit if user not logged in' do
    bulletin_draft = bulletins(:draft)

    get edit_bulletin_url(bulletin_draft)
    assert_redirected_to root_url
  end

  test 'update bulletin' do
    @bulletin = bulletins(:draft)
    sign_in(@user)

    patch bulletin_url(@bulletin), params: { bulletin: @attrs }

    assert_redirected_to bulletin_url(@bulletin)

    assert(@bulletin.title, @attrs[:title])
    assert(@bulletin.description, @attrs[:description])
  end

  test 'not update if user not logged in' do
    @bulletin = bulletins(:draft)
    patch bulletin_url(@bulletin), params: { bulletin: @attrs }

    @bulletin.reload

    assert_redirected_to root_url
    assert(@bulletin.title != @attrs[:title])
  end

  test 'not author cant update bulletin' do
    user = users(:second)
    sign_in(user)
    patch bulletin_url(@bulletin), params: { bulletin: @attrs }

    @bulletin.reload

    assert(@bulletin.title != @attrs[:title])
    assert_redirected_to root_url
  end

  test 'archive published' do
    sign_in(@user)

    patch archive_bulletin_url(@bulletin)

    @bulletin.reload

    assert_redirected_to profile_url
    assert(@bulletin.archived?)
  end

  test 'guest cant archive published' do
    patch archive_bulletin_url(@bulletin)

    @bulletin.reload

    assert_redirected_to root_url
    assert_not(@bulletin.archived?)
  end

  test 'not author cant archive published' do
    user = users(:second)
    sign_in(user)

    patch archive_bulletin_url(@bulletin)

    @bulletin.reload

    assert_redirected_to root_url
    assert_not(@bulletin.archived?)
  end

  test 'to_moderate draft' do
    sign_in(@user)
    @bulletin = bulletins(:draft)

    patch to_moderate_bulletin_url(@bulletin)

    @bulletin.reload

    assert_redirected_to profile_url
    assert(@bulletin.under_moderation?)
  end

  test 'guest cant to_moderate published' do
    patch to_moderate_bulletin_url(@bulletin)

    @bulletin.reload

    assert_redirected_to root_url
    assert_not(@bulletin.under_moderation?)
  end

  test 'not author cant to_moderate published' do
    user = users(:second)
    sign_in(user)

    patch to_moderate_bulletin_url(@bulletin)

    @bulletin.reload

    assert_redirected_to root_url
    assert_not(@bulletin.under_moderation?)
  end
end
