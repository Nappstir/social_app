require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:ExampleUser)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select "div.pagination"
  end

  test "micropost INVALID submission" do
    log_in_as(@user)
    get root_path
    assert_no_difference "Micropost.count" do
      post microposts_path, micropost: { content: "" }
    end
    assert_select "div#error_explanation"
  end

  test "micropost VALID submission" do
    log_in_as(@user)
    get root_path
    content = "This is valid micropost"
    assert_difference "Micropost.count", 1 do
      post microposts_path, micropost: { content: content }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_match content, response.body
  end

  test "delete a micropost" do
    log_in_as(@user)
    get root_path
    assert_select 'a', text: "delete"
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end
  end

  test "delete not available for other users" do
    get user_path(users(:OtherUser))
    assert_select 'a', text: "delete", count: 0
  end

end
