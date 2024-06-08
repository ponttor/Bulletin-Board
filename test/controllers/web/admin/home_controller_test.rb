# frozen_string_literal: true

require 'test_helper'

class Web::Admin::HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
  end

  test 'index' do
    sign_in(@admin)
    get admin_root_path

    assert_response :success
  end

  test 'profile not accessed by not admin' do
    user = users(:one)
    sign_in(user)
    get admin_root_path

    assert_redirected_to root_path
  end
end
