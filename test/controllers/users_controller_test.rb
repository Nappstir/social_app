require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get signup" do
    get :new
    assert_response :success
    assert_select "title", "Sign up | Social App"
  end

end
