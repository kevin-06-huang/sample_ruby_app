# this is generated with the following command:
# $ rails generate controller AccountActivations
# refer to 10.1.1
class AccountActivationsController < ApplicationController
  # from listing 10.29, this is the edit action to activate user
  def edit
    user = User.find_by(email: params[:email])
    # we also check if the user is activated or not, because if we do not
    # it is possible for another user to reuse the activation link to log
    # in as the user, since we login the user automatically upon
    # successful activation
    if(user && !user.activated? && user.authenticated?(:activation, params[:id]))
    # user.update_attribute(:activated, true)
    # user.update_attribute(:activated_at, Time.zone.now)
      # refactored in listing 10.35
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link."
      redirect_to root_url
    end
  end
end
