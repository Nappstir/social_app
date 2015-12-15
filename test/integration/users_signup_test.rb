require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  # !!!IMPORTANT
  # In order for the assert_template to work, its necessary for the Users routes, Users show action, & show.html.erb view to work correctly.As a result `assert_template` works as an end-to-end coverage of important application features.

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {name: "", email: "user@invalid", password: "foo", password_confirmation: "bar"}
    end
    assert_template 'users/new'
    # Verify that errors render after incomplete submission
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  test "valid signup information" do
    assert_difference "User.count", 1 do
      post_via_redirect users_path, user: {name: "Example", email: "example@testing.com", password: "foobar", password_confirmation: "foobar" }
    end
  end
end
