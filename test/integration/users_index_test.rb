# this is generated with the following rails command:
# $ rails generate integration_test users_index

require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # added in listing 9.44
# def setup
#   @user = users(:test)
# end
  
  # added from listing 9.57, this just setup the admin and non-admin for
  # use in the test
  def setup
    @admin = users(:test)
    @non_admin = users(:test2)
  end
  
# test "index including pagination" do
#   log_in_as(@user)
    # sends a get request for users_path, ie index
#   get users_path
    # check for the presence of an index view
#   assert_template 'users/index'
    # go through the list of user in first page checking that for each user
    # the name is present on the page, along with a link to their profile
#   User.paginate(page: 1).each do |user|
#     assert_select 'a[href=?]', user_path(user), text: user.name
#   end
# end

  # added from listing 9.57, this changes the previous test into a more
  # comprehesive one that accounts for the existence of an admin class of
  # users, whose index page would be different with delete link
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    # check there are div container of the class pagination, ie, proper
    # pagination
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    # check the first page to see if each user has a delete link, and also
    # skipping the test if the user is the @admin (u should not be able to
    # delete yourself)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete',
                                                    method: :delete
      end
    end
    # check that User.count does decrease by 1 after a delete request
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    # simply check for the existence of a link with text delete, there
    # should not be any
    assert_select 'a', text: 'delete', count: 0
  end
end
