# this is added in 11.2.3, generated using the following command:
# $ rails generate integration_test users_profile
require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  # we added the rest of the test manually via listing 11.27
  # this include is simply here to let us use the full_title helper
  # method we've already defined in application helper
  include ApplicationHelper
  
  def setup
    @user = users(:test)
  end
  
  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    # this check for an image tag with class gravatar inside a h1 tag
    assert_select 'h1>img.gravatar'
    # this line match the number of microposts (which we expect to
    # be displayed on the view somewhere) to the full html source of
    # the page, which is given by response.body
    # assert_match does not require us to indicate which HTML tag we're
    # looking for; assert_select is more specific and works with cs
    # selector to look for specific tags
    assert_match @user.microposts.count.to_s, response.body
    # why is this line of assertion failing? ive looked through the
    # book and the html source, this should not be failing
    assert_select 'div.pagination'
    # why does this work then?
    assert_match 'div.pagination', response.body
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end

 # $ bundle exec rake test TEST=test/integration/users_login_test.rb \
  # TESTOPTS="--name test_login_with_valid_information"
  # this runs a specific test within a test file