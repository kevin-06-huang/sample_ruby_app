# generate from the following command:
# $ rails generate integration_test following
require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  # added from listing 12.28
  def setup
    @user = users(:michael)
    @user2 = users(:lana)
    log_in_as(@user)
  end
  
  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    # remember response.body is the body of the entire http response, and
    # we're simply looking for a match in string of the number of user's
    # followed (called following) in the response body
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
  
  test "followers page" do
    get followers_user_path(@user)
    # this is included to make sure the each assertion that follows is not
    # vacuously true, ie, assertion pass because @user is empty
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
  
  # added from listing 12.39
  test "should follow a user the html way" do
    assert_difference "@user.following.count", 1 do
      post relationships_path, followed_id: @user2.id
    end
  end
  
  test "should follow a user with ajax" do
    assert_difference "@user.following.count", 1 do
      xhr :post, relationships_path, followed_id: @user2.id
    end
  end
  
  test "should unfollow a user the standard way" do
    @user.follow(@user2)
    relationship = @user.active_relationships.find_by(followed_id: @user2.id)
    assert_difference "@user.following.count", -1 do
      delete relationship_path(relationship)
    end
  end
  test "should unfollow a user with ajax" do
    @user.follow(@user2)
    relationship = @user.active_relationships.find_by(followed_id: @user2.id)
    assert_difference "@user.following.count", -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end