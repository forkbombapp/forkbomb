class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def github
    Github.new :oauth_token => ENV['FORKBOMB_GITHUB_OAUTH_TOKEN']
  end
  
  def index
  end
end
