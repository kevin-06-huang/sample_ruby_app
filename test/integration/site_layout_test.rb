# this is an automatic integration test automatically generated with the following:
# rails generate integration_test site_layout
# to read up go to section 5.2
require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
   test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
   end
end
# bundle exec rake test:integration will test only integration test
# bundle exec rake test for all tests