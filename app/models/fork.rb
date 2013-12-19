class Fork < ActiveRecord::Base
  
  before_save :set_update_frequencies
  
  def self.get_for_user(user)
    user_forks = Fork.where(user: user.login)
    
    if user_forks.count == 0 || user_forks.last.updated_at <= 1.day.ago 
      forks = Rails.application.github.repos.list(user: user.login, auto_pagination: true).select{|r| r.fork === true }
      forks.each do |fork|
        fork = Fork.find_or_initialize_by(
          repo_name: fork.name,
          user: user.login
        )
        fork.save
      end
    end
    Fork.where(user: user.login)
  end
  
  def to_param
    "#{user}/#{repo_name}"
  end
  
  def self.find_by_repo_path(path)
    user, repo = path.split('/', 2)
    Fork.where(user: user, repo_name: repo).first
  end

  def github_path
    "https://github.com/#{user}/#{repo_name}"
  end
  
  def current?
    true
  end
  
  def select_options
    options = {'Update Frequency' => nil, 'Daily' => 'daily', 'Weekly' => 'weekly', 'Monthly' => 'monthly'}
    options.delete('Update Frequency') if self.active == true
    options
  end
  
  private
  
    def set_update_frequencies
       self.update_frequency = nil if self.active == false
       self.update_frequency = "daily" if self.active == true && self.update_frequency.nil?
    end
  
end
