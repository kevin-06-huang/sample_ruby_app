# automatically generated in 10.2.5 using the following console command:
# $ rails generate integration_test password_resets
require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    # this remember clear the actionmailer catalog of emails for testing
    # so that count is correct
    ActionMailer::Base.deliveries.clear
    @user = users(:test)
  end
  
  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # checking for invalid email
    post password_resets_path, password_reset: { email: "" }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # valid email
    post password_resets_path, password_reset: { email: @user.email }
    # we check afterwards to ensure that the reset digest has been
    # altered in the database, the @user.reload is simply the most
    # up-to-date one
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    # checks for the presence of a single object in activemailer
    assert_equal 1, ActionMailer::Base.deliveries.size
    # check for a flash objet
    assert_not flash.empty?
    # check that redirect happen after
    assert_redirected_to root_url
    # this line simply change the variable user to something else? i
    # am somewhat confused by the line
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "barquux" }
    assert_select 'div#error_explanation'
    # Blank password
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "  ",
                  password_confirmation: "foobar" }
    assert_not flash.empty?
    assert_template 'password_resets/edit'
    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "foobaz" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
