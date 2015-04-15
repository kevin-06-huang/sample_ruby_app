class StaticPagesController < ApplicationController
  def home
    # added in listing 11.38; this is here to define @micropost with
    # association
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
