class ReposController < ApplicationController
  
  def index
    if current_user
      user = current_user.github_username
      @github_user = github.users.get user: user
      @user_repos = github.repos.list(user: user, auto_pagination: true).select{|r| r.fork === true }
      
      @orgs = github.orgs.list user: user
      
      @org_repos = {}
      
      @orgs.each do |org|
        @org_repos[org.login] = github.repos.list(user: org.login, auto_pagination: true).select{|r| r.fork === true }
      end
      
      render 'repos/index'
    else
      flash[:notice] = "You must be logged in to access this page"
      redirect_to('/')
    end
  end
  
end