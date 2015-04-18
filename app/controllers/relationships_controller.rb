# this is added in 12.2.4 to get the follow and unfollow button working;
# generated with the following command:
# $ rails generate controller Relationships
class RelationshipsController < ApplicationController
  # we added this to enforce log in before follow and unfollow action
  before_action :logged_in_user
  # both added from 12.32
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    # modified in listing 12.35 to respond to ajax
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    # the next section respond to ajax
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
