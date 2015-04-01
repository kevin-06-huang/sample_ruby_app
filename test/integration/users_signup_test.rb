# this test is automatically generated in 7.3.4 to test the sign-up
# form using an automated testing suite; the code to generate this class
# $ rails generate integration_test users_signup
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
  end
  # this part is added in 7.4.4 and listing 7.26; it is a test for valid
  # submission that works similarly to the invalid submission test we
  # wrote before. we simply compare the difference the User.count, and
  # in this case we expected User.count to increase by 1 after a
  # submission with valid user information
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      # the only difference between post_via_redirect and post is that
      # post_via_redirect arrages to follow the redirect after
      # submission
      post_via_redirect users_path, user: { name: "Example User",
                                            email: "user@example.com",
                                            password: "password",
                                            password_confirmation: "password" }
    end
    # this part checks that a submission direct you to the user profile
    # specifically, the way it checks is via the template render; thus
    # this one line will check the Users routes, the Users show action
    # and the show.html.erb view
    assert_template 'users/show'
  end
end
