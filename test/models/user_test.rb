require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # we begin editing this part starting in listing 6.5
  # the setup method automatically gets run before each test, and is
  # used to create an instance variable @user that is available to all
  # the tests
  # test just model with $ bundle exec rake test:models
  def setup
  # @user = User.new(name: "Example User", email: "user@example.com")
  # we modified the previous line in listing 6.36 to get the test suite
  # passing again by making a test user with password and confirmation
    @user = User.new(name: "Example User",
                     email: "user@example.com",
                     password: "foobar",
                     password_confirmation: "foobar")
  end
  # this is an individual test; the assert succeeds if @user.valid?
  # return true and fails if false
  test "should be valid" do
    assert @user.valid?
  end
  # this is a test that test validation for presence of name; if name
  # is not present, the test should fail, ie, assert_not
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  # these are tests for length validation for the input field name and 
  # email for user, added in 6.2.3
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  # these are tests for valid email formats that are added in 6.18
  test "email validation should accept valid addresses" do
    valid_addresses = %w[ user@example.com
                          USER@foo.COM 
                          A_US-ER@foo.bar.org
                          first.last@foo.jp
                          alice+bob@baz.cn ]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      # here an optional second argument was passed into assertion to
      # produce a custom error message identifying which of the address
      # caused the test to fail
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  # these are tests that test for invalidity of invalid email addresses
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[ user@example,com
                            user_at_foo.org
                            user.name@example.
                            foo@bar_baz.com
                            foo@bar+baz.com ]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address} should be invalid"
    end
  end
  # this is added from listing 6.23; it is a test for the rejection of
  # duplicate email addresses.
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    # added in 6.25 to allow for cases so that email addresses are
    # processed as if they are case insensitive
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  # this is a test added in 6.3.3, listing 6.38, to test for a minimum
  # password length of 6
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "2" * 5
    assert_not @user.valid?
  end
  # this is added in 8.4.4, listing 8.43 to test for the issue with having
  # multiple windows open and having the remember_digest alter by one
  # window; specifically the authenticated? helper method we wrote in user
  # in model should return false for a user with nil remember digest
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  # this is added in listing 11.19, testing the dependent: :destroy
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  # listing 12.9, testing for following utility
  test "should follow and unfollow a user" do
    test = users(:michael)
    test2 = users(:archer)
    # following? is a helper method we defined in model/user.rb
    assert_not test.following?(test2)
    test.follow(test2)
    assert test.following?(test2)
    # listing 12.13
    assert test2.followers.include?(test)
    test.unfollow(test2)
    assert_not test.following?(test2)
  end
end
