# this is generated with: $ rails generate controller Users new

class UsersController < ApplicationController
  # added in 9.2.1, from listing 9.12, before_action arrange for
  # certain methods to be called before the given actions. logged_in_user
  # is a helper method we added to the bottom, to confirm a user is logged
  # in and if they're not, direct them to the login page. Additionally, we
  # restricted the action with only: so that the before_action would not
  # be performed for methods that does not require it; by default, before
  # apply to every action in a controller
  before_action :logged_in_user, only: [:edit, :update]
  
  # this show method was put in to show the profile of a single user;
  # right now all it really does is set the @user variable to the actual
  # user retrieved from the database through the abstraction of the
  # activemodel. This is in section 7.3
  def show
    @user = User.find(params[:id])
    # section 7.1.3, just demonstrating how to use byebug gem
    # uncomment the following line to see a demonstration of how and
    # when to use byebug
   # debugger
  end
  
  # we start editing the new method in section 7.2.1
  def new
    @user = User.new
  end
  
  # this part is added in listing 7.16; we created an action create in 
  # the Users controller
  def create
    # this is functionally working, but insecure by default; since rails
    # 4.2 this now raises an error by default; this is called mass
    # assignment and prone to mass assignment insecurity - now replaced
    # by strong parameters - see section 7.3.1
  # @user = User.new(params[:user])
    # this is the better version implemented in 7.3.2; see the private
    # method user_params at bottom of class
    @user = User.new(user_params)
    if @user.save
      # added in 8.2.5, listing 8.22; just a minor tweak so that login
      # is automatic upon successful signing up; log_in is a helper
      # method defined in sessionshelper that is available to all
      # controllers
      log_in @user
      # this is added in 7.4.2; just a nice to have polish common in
      # web applications, a message that appears in the subsequent
      # page but disappears upon visiting another page or reloading
      # this merely instantiate the flash[:success]; additional code
      # is required to actually display the flash messages
      flash[:success] = "Welcome, #{@user.name}!"
      # listing 7.23
      redirect_to @user
      # actually should be redirect_to user_url(@user), but the previous
      # line is sufficient; rails automatically infers the rest
    else
      render 'new'
    end
  end
  
  # added in section 9.1.1, listing 9.1, an edit method that starts off by
  # pulling the relevant user from the database using the params[:id]
  def edit
    @user = User.find(params[:id])
  end
  
  # added in 9.1.2, from listing 9.5, this is a user update action for
  # editing current user that re-render the 'edit' view if user edit fails
  # the use of user_params method is again, to prevent mass assignment
  # vulnerability
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #my own addition
      flash[:success] = "Profile successfully updated, #{@user.name}"
      # further edited in listing 9.9
      # this is the better one, because show access the database, and
      # @user is already instantiated
      redirect_to @user
    # render 'show'
    else
      render 'edit'
    end
  end
  
  # this is now the preferred way for passing in params from view - we
  # write a private method accessible from only inside the Users
  # controller. the method - called user_params simply returned
  # params[:user] but with only the permitted value to prevent mass
  # security vulnerabilities
  private
    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password,
                                   :password_confirmation)
    end
    
    # added in 9.2.1, from listing 9.12, to confirm a user is logged in,
    # and if they're not, direct them to the login page; logged_in? is
    # a helper method we defined earlier in sessions_helper.rb, remember
    # helper methods are available to all controllers and views
    def logged_in_user
      unless logged_in?
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