class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # this is added in 8.2, listing 8.11, to include the automatically
  # generated sessions_helper module in the base class of all controller
  # so that it is available to all controllers
  include SessionsHelper
end
