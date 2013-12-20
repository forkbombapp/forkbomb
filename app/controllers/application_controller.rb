class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def after_sign_in_path_for(resource)
    forks_path
  end
  
  def sign_out
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end
  
  def index
    redirect_to forks_path and return if signed_in?
  end
end
