require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

# User validation tests for name
  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "name should not exceed 50 characters" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

# User validation test for email
  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "email should not exceed 255 characters" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validations should accept valid email addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validations should reject invalid email addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be saved as lowercase" do
    mixed_case_email = "TEst@GmAiL.COM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # User validation test for password
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length of six characters" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  # User following & unfollowing
  test "should follow and unfollow a user" do
    ExampleUser = users(:ExampleUser)
    OtherUser = users(:OtherUser)
    assert_not ExampleUser.following?(OtherUser)
    ExampleUser.follow(OtherUser)
    assert ExampleUser.following?(OtherUser)
    assert OtherUser.followers.include?(ExampleUser)
    ExampleUser.unfollow(OtherUser)
    assert_not ExampleUser.following?(OtherUser)
  end

  # Users feed will show right posts
  test "feed should have the right posts" do
    example_user = users(:ExampleUser)
    other_user = users(:OtherUser)
    user_1 = users(:user_1)
    # Posts from followed user
    user_1.microposts.each do |post_following|
      assert example_user.feed.include?(post_following)
    end
    # Posts from self
    example_user.microposts.each do |post_self|
      assert example_user.feed.include?(post_self)
    end
    # Posts from unfollowed user
    other_user.microposts.each do |post_other|
      assert_not example_user.feed.include?(post_other)
    end
  end

end
