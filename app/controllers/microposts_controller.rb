# this is added from 11.2.1, auto generated using the following command:
# $ rails generate controller Microposts
class MicropostsController < ApplicationController
  # added in listing 11.32, to ensure valid user is logged in
  before_action :logged_in_user, only: [:create, :destroy]
  # added in listing 11.50 to ensure only the correct_user may delete
  # a micropost
  before_action :correct_user, only: :destroy
  # this is added in listing 11.34; we added these methods and the
  # private one underneath to implement the create action
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  # defined in listing 11.50
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted."
    # request.referrer is a method that is closely related to the
    # request.url variable used in friendly forwarding and is just the
    # previous URL
    redirect_to request.referrer || root_url
  end
  
  private
    # modified in listing 11.58 to add picture to the list of permitted
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
    # added in listing 11.50
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
