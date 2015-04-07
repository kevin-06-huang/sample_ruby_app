ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  # this helper method is added in 8.2.5; it is analagous to the
  # logged_in? helper method defined in sessions_helper, however,
  # because helper methods aren't available in tests, we can't use the
  # current_user and logged_in? we've defined already in sessions_helper
  # but must use the session method, which is a predefined rails method
  
  # added from listing 8.23; returns true if a test user is logged in
  def is_logged_in?
    !session[:user_id].nil?
  end

  # this part is added in listing 8.50
  # log in a test user
  def log_in_as(user, options = {})
    
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    
    if integration_test?
      post login_path, session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me }
                                  
    else
      session[:user_id] = user.id
    end
  end

  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end
end
