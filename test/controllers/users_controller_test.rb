require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  # this part is added from listing 9.17, and is a test meant to test the
  # before action; the before action (in user controller) is meant to
  # ensure that certain actions require login. We put this test into users
  # controller test because the before filter operates on a per-action
  # basis and this is a test that correspond to a user controller test
  def setup
    # remember, we have to do this step to put our test user in the
    # database; users here refer to the fixture users.yml
    @user = users(:test)
    # added from listing 9.21 to set up a second user in order to test
    # for trying to edit the wrong user
    @user2 = users(:test2)
  end
  
  # this test is added in 9.3.1, listing 9.31; it simply test to see if
  # a user that is not logged in attempt to visit the index, they are
  # asked to login
  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end
  
  test "should get new" do
    # sends a http request GET to retrieve the new view
    get :new
    # check the http response, which should be successful
    assert_response :success
  end
  
  test "should redirect edit when not logged in" do
    # this is rails convention; id: @user automatically uses @user.id;
    # it is rails convention to use the get and patch method as follows
    # get :edit, id: @user
    # patch :update, id: @user, user: { name: @user.name, email: @user.email }
    get :edit, id: @user
    # flash should not be empty, ie, there should be a flash message
    # informing the user of error
    assert_not flash.empty?
    # check that the redirect is to the login page
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    # patch requires an additional user hash in order for the route to work
    # properly
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  # added from listing 9.21, to test for what happened when user try to
  # edit a profile that's not their own
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@user2)
    get :edit, id: @user
    # here the expected behaviour is to simply redirect to the root page
    assert flash.empty?
    assert_redirected_to root_url
  end
  # again, added from listing 9.21
  test "should redirect update when logged in as wrong user" do
    log_in_as(@user2)
    patch :update, id: @user, user: { name: @user2.name, email: @user2.email }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  # added from listing 9.56; we are testing for admin access control. The
  # test is action-level access control, hence why we put the test here
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      # issuing a delete request; there should be no difference in user
      # count afterwards and the user should be redirected to the login
      # page
      delete :destroy, id: @user2
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@user2)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end
end
