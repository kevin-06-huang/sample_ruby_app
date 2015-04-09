# this testing file is generated with the following command:
# $ rails generate integration_test users_edit
require 'test_helper'

# added in 9.1.3, from listing 9.6, this is an itegration test to check for
# regressions, specifically the action of editing a user
class UsersEditTest < ActionDispatch::IntegrationTest
  # this set up the test user to be tested in the database
  def setup
    # again, this refers to test/fixtures/users.yml, specifically the case
    # test
    @user = users(:test)
  end
  
  test "unsuccessful edit" do
    # added from listing 9.14, to log in the test user; also, log_in_as is
    # a helper method for tests, written earlier in test_helper.rb
    log_in_as(@user)
    # send a get request to get the current user
    get edit_user_path(@user)
    # check that after the get request is sent, the current view (template)
    # is indeed the right one with path 'users/edit'
    assert_template 'users/edit'
    # submit an invalid edit request, ie, patch
    patch user_path(@user), user: { name:  "",
                                    email: "foo@invalid",
                                    password: "foo",
                                    password_confirmation: "bar" }
    # we expect the edit to fail, and therefore the template should stay on
    # the edit page, which is what we check for here
    assert_template "users/edit"
  end
  
  # this part is added in 9.1.4, from listing 9.8 and simply checks for a
  # successful edit.
  test "successful edit" do
    # added in listing 9.14
    log_in_as(@user)
    
    get edit_user_path(@user)
    assert_template "users/edit"
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: "",
                                    password_confirmation: "" }
    # because flash is an empty container that gets filled up with flash
    # messages and display them, here we check that flash container is not
    # empty
    assert_not flash.empty?
    # we check that after the successful edit, we are redirected back to
    # the user profile
    assert_redirected_to @user
    # this reloads the user's value from the database, so that they may be
    # checked next to verify successful update of the attributes in the
    # database
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
end
