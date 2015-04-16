# this is created with the following command:
# rails generate integration_test microposts_interface
require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # added from listing 11.53
  def setup
    @user = users(:test)
  end
  
  test "micropost interface" do
    # login test user
    log_in_as(@user)
    # go to home page
    get root_path
    # check there is div tage class pagination
    assert_select 'div.pagination'
    # check that empty post does not get posted
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: "" }
    end
    # check that an error flag shows up
    assert_select 'div#error_explanation'
    content = "This micropost really ties the room together"
    # check that content with proper text is successfully posted
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content }
    end
    # route test user to homepage
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # we look for delete link by micropost
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    get user_path(users(:test2))
    assert_select 'a', text: 'delete', count: 0
  end
end
