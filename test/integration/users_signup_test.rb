# this test is automatically generated in 7.3.4 to test the sign-up
# form using an automated testing suite; the code to generate this class
# $ rails generate integration_test users_signup
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # we again modified this test class at this juncture in order to test
  # additional functionalities that we have implemented, specifically
  # activatation and the refactoring
  def setup
    # this clears the deliveries array, a global array of messages
    # delivered. because of its global nature, and since part of our test
    # verifies exactly one activation email is sent we must reset its
    # value for the test to work
    ActionMailer::Base.deliveries.clear
  end
  
  # from listing 7.21, a test for invalid signup information that works
  # by comparing user.count before and after signing up with invalid
  # users, asserting that user.count does not increase
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                               email: "user@invalid",
                               password: "ahh",
                               password_confirmation: "bar" }
    end
    # this part checks that a failed submission re-renders the new action
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  # this part is added in 7.4.4 and listing 7.26; it is a test for valid
  # submission that works similarly to the invalid submission test we
  # wrote before. we simply compare the difference the User.count, and
  # in this case we expected User.count to increase by 1 after a
  # submission with valid user information
  
  #additionally modified according to listing 10.31
  test "valid signup information with account activation" do
    # this sends a get request to signup path
    get signup_path
    # check that after we send a post request the user count increment by
    # one
    assert_difference 'User.count', 1 do
      post users_path, user: { name: "Example User",
                               email: "user@example.com",
                               password: "password",
                               password_confirmation: "password" }
    end
    # checks that one message is delivered
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in?
    # check for invalid activation token; since we automatially logged in
    # the user we can verify that the user is logged in or not to check
    # if activation succeeded or not
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # check for valid token, invalid email address; again, verifying if
    # user is logged in or not
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
      
      # the only difference between post_via_redirect and post is that
      # post_via_redirect arrages to follow the redirect after
      # submission
    # post_via_redirect users_path, user: { name: "Example User",
    #                                       email: "user@example.com",
    #                                       password: "password",
    #                                       password_confirmation: "password" }
  # end
    # this part checks that a submission direct you to the user profile
    # specifically, the way it checks is via the template render; thus
    # this one line will check the Users routes, the Users show action
    # and the show.html.erb view
    
    # we commented out the next two lines in listing 10.22 because after
    # putting in activation in our account, the behaviour after creating a
    # new user is no longer to return
    
  # assert_template 'users/show'
    # added in listing 8.24; makes use of the is_logged_in? test helper
    # method that we defined in listing 8.23 and the test_helper.rb;
    # simply test if the test user is logged in with valid information
  # assert is_logged_in?
# end
end
