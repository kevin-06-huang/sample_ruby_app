class StaticPagesController < ApplicationController
  def home
    # added in listing 11.38; this is here to define @micropost with
    # association
    @micropost = current_user.microposts.build if logged_in?
    # added from listing 11.45, this adds a @feed_items instance
    # variable for the current user's feed; feed is defined in user.rb in
    # model from listing 11.44
    @feed_items = current_user.feed.paginate(page: params[:page]) if logged_in?
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
