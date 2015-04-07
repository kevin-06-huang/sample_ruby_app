# this is generated in section 8.1.5, using the following command:
# $ rails generate integration_test users_login
require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # this is added from listing 8.20; it set up the @user variable
  # according to the fixture we've defined in users.yml in test/fixtures
  def setup
    @user = users(:test)
  end
  # this is from listing 8.7
  test "login with invalid information" do
    # visit the login path
    get login_path
    # check that there is a template for new session that renders
    assert_template "sessions/new"
    # post to the login session with an invalid params
    post login_path, session: { email: "", password: "" }
    # check that the new session is re-rendered
    assert_template 'sessions/new'
    # check that a flash message appears
    assert_not flash.empty?
    # visit another page, in this case the root_path, the home page
    get root_path
    # check again for a flash message, only this time verifying that it
    # does not appear
    assert flash.empty?
  end
  # also, to run just a single test:
  # $ bundle exec rake test TEST=test/integration/users_login_test.rb
  
  # added from listing 8.20, second part:
  test "login with valid information" do
    get login_path
    post login_path, session: { email: @user.email, password: 'foobar' }
    # notice here we're using a test helper method; also this is added in
    # listing 8.28
    assert is_logged_in?
    # check the redirect target is correct, ie, @user
    assert_redirected_to @user
    # this actually visit the redirect page
    follow_redirect!
    assert_template 'users/show'
    # check that login_path is absent (expect 0 login_path)
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    # further modified in listing 8.28 to test logout as well
    # this line sends a delete request to the url at logout_path, in other
    # words this is simply destroying a session, ie, logging out
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # from listing 8.40, specifically testing the fact logged out should
    # only happen if user is not logged in; test involves sending second
    # logout request
    delete logout_path
    follow_redirect!
    # check that the page is dynamically updated based on whether or not
    # there is a current user logged in
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  # $ bundle exec rake test TEST=test/integration/users_login_test.rb \
  # TESTOPTS="--name test_login_with_valid_information"
  # this runs a specific test within a test file
  
  # this part is added in listing 8.51 to test the behaviour of loggin in
  # with the remember me box checked and without. both of these tests used
  # the helper method we've defined in test_helper, remembering that helpers
  # are not available for tests if they are not in test_helper.rb
  # additionally, the cookies method for some reason doesn't work with
  # symbols as keys inside tests (prob a bug), and that is why here we have
  # written them with string keys instead
  
  # i've figured it out, there is a bug with the assertion, it's testing the
  # assertion after the second log_in_as was executed, not before, if the
  # tests are run individually they passed, it's only when they are run
  # together that the first one failed
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end
