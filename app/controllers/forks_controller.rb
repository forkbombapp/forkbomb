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
                :repo_name => params[:fork][:repo_name],
                :owner      => params[:fork][:owner]
              ).first
                      
      fork.update_attributes(params[:fork].permit(:active, :update_frequency))
      
      if fork.valid?
        render json: fork, status: :created, location: fork
      else
        render json: fork.errors, status: :unprocessable_entity
      end
    end
  end
  
  def show
    @fork = Fork.find_by_repo_path(params[:id])
  end

  def badge
    @fork = Fork.find_by_repo_path(params[:fork_id])
    if @fork.current?
      state_str = 'current'
    elsif @fork.behind_by.nil?
      state_str = 'unknown'
    else
      state_str = 'behind'
    end      
    respond_to do |wants|
      wants.png { send_file File.join(Rails.root, 'app', 'views', 'forks', "#{state_str}.png"), disposition: 'inline' }
    end
  end
  
end