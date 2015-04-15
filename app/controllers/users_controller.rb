# this is generated with: $ rails generate controller Users new

class UsersController < ApplicationController
  # added in 9.2.1, from listing 9.12, before_action arrange for
  # certain methods to be called before the given actions. logged_in_user
  # is a helper method we added to the bottom, to confirm a user is logged
  # in and if they're not, direct them to the login page. Additionally, we
  # restricted the action with only: so that the before_action would not
  # be performed for methods that does not require it; by default, before
  # apply to every action in a controller
  
  # :destroy is added to the logged_in_user before_action in listing 9.53
  # to ensure that users have to be logged in to delete users
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  
  # this is added from listing 9.22; we added another before action
  # that called a helper method correct_user; also note that this has
  # the effect of defining the @user variable, which is why those are
  # commented out
  before_action :correct_user, only: [:edit, :update]
  
  # added from listing 9.54, we restrict the destroy action to admins;
  # this make sure that user cannot issue delete request using command
  # line
  before_action :admin_user, only: :destroy
  
  # this is added in listing 9.32, while also adding index as an action
  # to the before filer for logged_in_user
  # listing 9.33 completes it
  def index
  # @users = User.all
    # we replace the previous line with the paginate method to paginate
    # the index; this is added in listing 9.42
    # i also further modified it to only show users that are activated
    @users = User.where("activated = ?", true).paginate(page: params[:page])
  end
  
  # this show method was put in to show the profile of a single user;
  # right now all it really does is set the @user variable to the actual
  # user retrieved from the database through the abstraction of the
  # activemodel. This is in section 7.3
  def show
    @user = User.find(params[:id])
    # section 7.1.3, just demonstrating how to use byebug gem
    # uncomment the following line to see a demonstration of how and
    # when to use byebug
    @microposts = @user.microposts.paginate(page: params[:page])
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
    # log_in @user
      # this is added in 7.4.2; just a nice to have polish common in
      # web applications, a message that appears in the subsequent
      # page but disappears upon visiting another page or reloading
      # this merely instantiate the flash[:success]; additional code
      # is required to actually display the flash messages
    # flash[:success] = "Welcome, #{@user.name}!"
      # listing 7.23
    # redirect_to @user
      # actually should be redirect_to user_url(@user), but the previous
      # line is sufficient; rails automatically infers the rest
      
      # this is added in listing 10.21; we change the redirect_to to the
      # root_url because now that the account require activation, we can
      # no longer redirect directly to the @user profile
    # UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  # added in section 9.1.1, listing 9.1, an edit method that starts off by
  # pulling the relevant user from the database using the params[:id]
  def edit
  # @user = User.find(params[:id])
  end
  
  # added in 9.1.2, from listing 9.5, this is a user update action for
  # editing current user that re-render the 'edit' view if user edit fails
  # the use of user_params method is again, to prevent mass assignment
  # vulnerability
  def update
  # @user = User.find(params[:id])
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
  
  # added in listing 9.53, this is a destroy
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "#{params[:name]} deleted."
    # the user is then redirected to the index
    redirect_to users_url
  end
  
  private
    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password,
                                   :password_confirmation)
    end
    
   
    
    # added in listing 9.22, to confirm the correct user; also sets the
    # @user variable
    def correct_user
      @user = User.find(params[:id])
      # because if the actions edit and update were called, there should
      # already be a logged in user due to the before action before this
      # is called. the next line simply compare the @user that we got
      # from the params which remember is basically the part of the url
      # and part of any update and edit request; if the edit and update
      # request is for another user, the params and the user found with
      # params will not match up with the user that is currently logged
      # in and has an active session; thus a redirect would happen
      # unless the correct user is present, ie, session user matches up
      # with the user that is the target of the requested change
      # this is further modified in listing 9.25, we simply refactor it
      # to take advantage of a helper method we wronte in sessions_helper
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # this is added from listing 9.54, similar to other helper methods
    # above this confirms that the current_user is an admin, and if not
    # a redirect to root occurs to prevent unauthorized action
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end