# frozen_string_literal: true

require 'test_helper'

class Web::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'destroy' do
    sign_in(@user)
    delete session_url

    assert_redirected_to root_url
    assert_not signed_in?
  end
end
