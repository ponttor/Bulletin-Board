# frozen_string_literal: true

require 'test_helper'

class Web::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test 'not show' do
    get profile_path

    assert_redirected_to root_url
  end

  test 'show' do
    @user = users(:one)
    sign_in(@user)
    get profile_path

    assert_response :success
  end
end
