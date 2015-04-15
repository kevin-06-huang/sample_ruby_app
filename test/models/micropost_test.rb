require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # these are all added from listing 11.2
  def setup
    @user = users(:test)
    # similar to new, build returns an object in memory but does not
    # modify the database
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end
  test "should be valid" do
    assert @micropost.valid?
  end
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  # added from listing 11.6
  test "content should be present" do
    @micropost.content = ""
    assert_not @micropost.valid?
  end
  # added from listing 11.6
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  # added from listing 11.13, to verify the order of the microposts
  test "order should be most recent first" do
    assert_equal Micropost.first, microposts(:most_recent)
  end
end
