# this is generated in section 8.1.1 using the following command:
# $ rails generate controller Sessions new
# notice we didn't specify more actions; at this part we only need to
# specify the actions that has a corresponding view, since rails will
# automatically generate them
class SessionsController < ApplicationController
  def new
  end
  # this is added in section 8.1.3 from listing 8.4
  # further added to in listing 8.5, 8.6
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # we again alter this portion of this method from listing 10.30, now
      # to additionally check for activation
      if user.activated?
        log_in user
        flash[:success] = "Welcome, #{user.name}"
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = "#{user.name}, please activate your account"
        redirect_to root_url
      end
      
      # log the user in and redirect to the user's page
   #  log_in user
      # i added this part
   #  flash[:success] = "Welcome, #{user.name}"
      # added in listing 8.34, to remember the user in a cookie. the
      # remember(user) method is defined in sessionshelper
    # remember user
      # added from listing 8.49; the less compact form is:
    # if params[:session][:remember_me] == '1'
    #   remember(user)
    # else
    #   forget(user)
    # end
    # params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      
    # redirect_to user
    
      # added in listing 9.29 to replace the previous line, this makes
      # use of the helper method we wrote in sessions_helper, and redirect
      # to the page user is trying to access before prompt for a login;
      # if there is no such page, the redirect happens to the default page
      # which is passed into the helper method as a parameter
    # redirect_back_or user
      # redirect_to user is automatically converted by rails into the
      # route user_url(user)
    else
    # flash[:danger] = 'Invalid email/password combination'
      # this fixes the bug so that the flash message will now disappear
      # as soon as an additional request appear, whereas before a
      # redirect is required
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  # added in 8.3 from listing 8.27, for destroying a session and logging
  # out a user using the log_out helper method that was defined in
  # sessions_helper
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
