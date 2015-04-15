class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # this is added in 8.2, listing 8.11, to include the automatically
  # generated sessions_helper module in the base class of all controller
  # so that it is available to all controllers
  include SessionsHelper
  
  private
  # this is moved in listing 11.31 from the users controller to
  # here because we now need to use this method for microcontroller as
  # well
 # added in 9.2.1, from listing 9.12, to confirm a user is logged in,
    # and if they're not, direct them to the login page; logged_in? is
    # a helper method we defined earlier in sessions_helper.rb, remember
    # helper methods are available to all controllers and views
    def logged_in_user
      unless logged_in?
        # making use of the helper method store_location, defined in
        # sessions_helper, this is added from listing 9.28
        store_location
        
        flash[:danger] = "Please log in."
        # _path are for views because ahrefs are implicitly linked to the
        # current URL, _url is needed for redirect_to and for linking SSL
        # site to non-SSL site and vice versa; former because the HTTP
        # specification specifically state that for 3xx redirect response
        # the Location header must be in absolute URL, latter because
        # absolute URI is needed to get the right https prefix; both
        # seems to work interchangeably fine though
        redirect_to login_url
      end
    end
end
