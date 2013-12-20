class Fork < ActiveRecord::Base
  
  before_save :set_update_frequencies
  after_save :enqueue
  
  def self.get_for_user(user)
    user_forks = Fork.where(owner: user.login)
    
    if user_forks.count == 0 || user_forks.last.updated_at <= 1.day.ago 
      forks = Rails.application.github.repos.list(user: user.login, auto_pagination: true).select{|r| r.fork === true }
      forks.each do |fork|
        fork = Fork.find_or_initialize_by(
          repo_name: fork.name,
          owner: user.login
        )
        fork.save
      end
    end
    Fork.where(owner: user.login)
  end
  
  def generate_pr
    # get repository details
    repo = Rails.application.github.repos.get self.owner, self.repo_name

    if repo.parent
      branch = repo.default_branch
      upstream_owner = repo.parent.owner.login
      upstream_branch = repo.parent.default_branch

      begin
        Rails.application.github.pulls.create(owner, repo_name,
          title: 'Upstream changes',
          body: 'Automatically opened by http://forkbomb.io',
          head: "#{upstream_owner}:#{upstream_branch}",
          base: branch
        )
      rescue Github::Error::UnprocessableEntity => ex
        # absorb errors caused by already-open PRs or zero-size PRs
        raise unless ex.message.include?("A pull request already exists") || ex.message.include?("No commits between")
      end

    end
    enqueue
  end
  
  def to_param
    "#{owner}/#{repo_name}"
  end
  
  def self.find_by_repo_path(path)
    owner, repo = path.split('/', 2)
    Fork.where(owner: owner, repo_name: repo).first
  end

  def github_path
    "https://github.com/#{owner}/#{repo_name}"
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
    
    def enqueue
      delay(run_at: next_run_time).generate_pr if active
    end

    def next_run_time
      case self.update_frequency
      when 'daily'
        1.day.from_now.at_midnight
      when 'weekly'
        1.week.from_now.beginning_of_week
      when 'monthly'
        1.month.from_now.beginning_of_month
      end
    end
  
end
