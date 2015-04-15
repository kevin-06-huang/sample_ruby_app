# this is added from 11.2.1, auto generated using the following command:
# $ rails generate controller Microposts
class MicropostsController < ApplicationController
  # added in listing 11.32, to ensure valid user is logged in
  before_action :logged_in_user, only: [:create, :destroy]
  # this is added in listing 11.34; we added these methods and the
  # private one underneath to implement the create action
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
       render 'static_pages/home'
    end
  end

  def destroy
  end
  
  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
