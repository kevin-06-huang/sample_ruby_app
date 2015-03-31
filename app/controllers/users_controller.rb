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
end
