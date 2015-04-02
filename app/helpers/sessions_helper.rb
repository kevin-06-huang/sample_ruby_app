# this is automatically generated when we generate the controller
module SessionsHelper
  # added in 8.2.1, listing 8.12
  # logs in the given user
  def log_in(user)
    # session is a predefined rails method that places a temporary
    # cookie on the user's browser containing an encrypted version
    # of the user's id; the temporary cookie expires immediately when
    # browser is closed
    # additionally, this method is placed in the sessionshelper because
    # login is used in several different place, and we've made this
    # helper module available to all controllers with the include we
    # added to the base applicationcontroller class
    session[:user_id] = user.id
  end
  # added in 8.4.2, listing 8.35
  # remembers a user in a persistent session; note that this is a different
  # method from the remember in user.rb of model, which remembers the user
  # to the database, specifically by generating a remember_digest and
  # storing it in the database
  def remember(user)
    user.remember
    # here, permanent is simply a shorthand way for ruby to set the expire
    # time to 20 years; you can set the expire time manually this way:
    # cookies[:remember_token] = { value:   remember_token,
    #                        expires: 20.years.from_now.utc }
    # equivalent to:
    # cookies.permanent[:remember_token] = remember_token
    # also, the signed tells the app to use a signed cookie, which encrypts
    # the id instead of leaving it as plain text
    # cookies is a predefined by rails and used to create permanent cookies
    # for the user id and remember token
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  # added in 8.2.2, listing 8.14
  # returns the current logged-in user (if any)
  def current_user
    # we use the find_by method, rather than find, because find method
    # raise an exception if user is not found, whereas find_by does not
    # raise an exception but simply return a nil value
    
    # additionally, we store the result of User.find_by in an instance
    # variable @current_user so that the application would not do a
    # lookup everytime current_user is used 
    
    # as per 8.1, the next line is simply the idiomatically correct way
    # of writing the following:
  # if @current_user.nil?
  #   @current_user = User.find_by(id: session[:user_id])
  # else
  #   @current_user
  # end
  # @current_user ||= User.find_by(id: session[:user_id])
  
  # from 8.4.2, listing 8.36, this is an updated current_user method that
  # also checks for a cookie before checking session. here user_id and user
  # are local variables defined only within the scope of the method
    # check to see if there is a session with id, if yes set local variable
    # user_id to the value
    if(user_id = session[:user_id])
      # return the current_user or retrieve the user info
      @current_user ||= User.find_by(id: user_id)
     # check to see, again, if a cookies exist
    elsif (user_id = cookies.signed[:user_id])
      # added in listing 8.53, raise an exception to show that for this part
      # no test code has been written
    # raise
      # retrieve the user associated with a particular id from the database
      user = User.find_by(id: user_id)
      # authenticate using the stored remember_token in cookie
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  # added in 8.2.3, listing 8.15
  # returns true if the user is logged in, ie, there is a current user
  # in the session, false otherwise
  def logged_in?
    !current_user.nil?
  end
  # forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  # added in section 8.3 from listing 8.26; simply a logout helper
  # method not unlike the log_in method before
  # log out the current user
  def log_out
    forget(current_user)
    # added in 8.4.3, from listing 8.39
    session.delete(:user_id)
    @current_user = nil
  end
end
