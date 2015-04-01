# this is generated with: $ rails generate controller Users new
class UsersController < ApplicationController
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
end