# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
  end

  test 'index' do
    get admin_root_url
    assert_response :success
  end

  test 'archive' do
    bulletin = bulletins(:published)
    patch archive_admin_bulletin_path(bulletin)

    bulletin.reload

    assert_redirected_to admin_bulletins_path
    assert(bulletin.archived?)
  end

  test 'publish' do
    bulletin = bulletins(:under_moderation)
    patch publish_admin_bulletin_path(bulletin)

    bulletin.reload

    assert_redirected_to admin_bulletins_path
    assert bulletin.published?
  end

  test 'reject' do
    bulletin = bulletins(:under_moderation)
    patch reject_admin_bulletin_path(bulletin)

    bulletin.reload

    assert_redirected_to admin_bulletins_path
    assert(bulletin.rejected?)
  end
end
