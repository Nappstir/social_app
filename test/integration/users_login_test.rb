require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:ExampleUser)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do

    # !!!! WILL TEST LOGIN PROCEDURE !!!!
    get login_path
    post login_path, session: { email: @user.email, password: "password" }
    assert is_logged_in?
    # Verify user is redirected to profile pg
    assert_redirected_to @user
    # Follow the redirect to test profile pg
    follow_redirect!
    assert_template "users/show"
    # Verify there are no login links
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    # !!!! WILL TEST LOGOUT PROCEDURE !!!!
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
