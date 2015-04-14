# this is automatically generated with the following console command:
# $ rails generate controller PasswordResets new edit --no-test-framework
# we include the flag to skip generating tests because we don't need the
# controller tests, since the integration test is sufficient
class PasswordResetsController < ApplicationController
  # as is customarily in rails, we use the before_action for those
  # actions that need to be executed multiple times and encapsulate
  # the logic in a helper method; this is added from listing 10.51
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  # added from listing 10.52, this simply checks the expiration date
  # again, the before_action is used to execute codes that applies
  # to more than one action, and check_expiration should apply to both
  # edit and update
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  # added from listing 10.41, this is the create action for password
  # resets
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions."
      redirect_to root_url
    else
      flash.now[:danger] = "Invalid email address."
      render 'new'
    end
  end
  
  def edit
  end
  # added in listing 10.52
  def update
    if password_blank?
      flash.now[:danger] = "Password cannot be blank."
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end
  private
    # both of these are added from listing 10.51; first one sets the
    # @user variable and the second one simply confirms that the user
    # exist, is activated, and that the reset token is authenticated
    def get_user
      @user = User.find_by(email: params[:email])
    end
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    # added from listing 10.52, this is like the previous two helper
    # method; encapsulating the logic allows us to use them as
    # before_action
    def check_expiration
      # also, password_reset_expired? is a helper method we defined
      # in user.rb in models from listing 10.53
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
    # also added from listing 10.52, this is the same strong parameter
    # as before
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    # this is a helper method added in listing 10.52 to catch the
    # error of having the password be blank; before, the bcrypt
    # has_secure automatically enforce this for us
    def password_blank?
      params[:user][:password].blank?
    end
end
