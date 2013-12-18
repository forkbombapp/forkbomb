class ForksController < ApplicationController
  
  def index
    if current_user
      user = current_user.github_username
      
      @github_user = Rails.application.github.users.get user: user      
      @user_repos = Fork.get_for_user(@github_user)
      
      @orgs = Rails.application.github.orgs.list user: user
      
      @org_repos = {}
      
      @orgs.each do |org|
        @org_repos[org.login] = Fork.get_for_user(org)
      end
      
      render 'forks/index'
    else
      flash[:notice] = "You must be logged in to access this page"
      redirect_to('/')
    end
  end
  
  def update
    if current_user
      fork = Fork.where(
                :repo_name => params[:fork]["repo_name"],
                :user      => params[:fork]["user"]
              ).first
              
      params.delete(:repo_name, :user)
              
      fork.update_attributes(params[:fork])
    end
  end
  
end