# this test is added from listing 12.30
require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  test "create should require logged-in user" do
    # before logged in we post a :create action to controller
    assert_no_difference 'Relationship.count' do
      post :create
    end
    assert_redirected_to login_url
  end
  
  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post :destroy, id: relationships(:one)
    end
    assert_redirected_to login_url
  end
end
