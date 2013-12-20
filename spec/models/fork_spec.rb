require 'spec_helper'

describe Fork do
  
  context "with user" do
  
    before(:each) do
      @user = Rails.application.github.users.get user: 'pezholio'
    end
  
    it "should retrieve a list of forks", :vcr do
      forks = Fork.get_for_user(@user)
      forks.count.should == 8
    end
  
    it "should fetch forks from the database if a cached version is present", :vcr do
      Fork.get_for_user(@user)
      Rails.application.github.should_not receive(:repos)
      Fork.get_for_user(@user)
    end
  
    it "should contact the API if the cache hasn't been updated in more than 1 day", :vcr do
      Fork.get_for_user(@user)
      Timecop.freeze(Date.today + 2) do
        Rails.application.github.repos.should receive(:list).and_call_original 
        Fork.get_for_user(@user)
      end
    end
    
  end
  
  context "testing status" do
  
    it "should mark forks that are behind as not current", :vcr do
      fork = FactoryGirl.create(:fork, owner: "theodi", repo_name: 'panopticon', active: true)
      fork.current?.should be_false
      fork.behind_by.should == 57
    end
  
    it "should mark forks that are up to date as current", :vcr do
      fork = FactoryGirl.create(:fork, owner: "theodi", repo_name: 'capsulecrm', active: true)
      fork.current?.should be_true
      fork.behind_by.should == 0
    end  
    
    it "should mark inactive forks as unknown", :vcr do
      fork = FactoryGirl.create(:fork, owner: "theodi", repo_name: 'capsulecrm', active: false)
      fork.current?.should be_false
      fork.behind_by.should == nil
    end  

  end
   
  it "should generate a param", :vcr do 
    fork = FactoryGirl.create(:fork, owner: 'batman', repo_name: 'batmobile')
    fork.to_param.should == "batman/batmobile"
  end
  
  it "should find forks by repo path", :vcr do
    fork = FactoryGirl.create(:fork, owner: 'batman', repo_name: 'batmobile')
    repo = Fork.find_by_repo_path('batman/batmobile')
    repo.owner.should == 'batman'
    repo.repo_name.should == 'batmobile'
  end
  
  it "should generate a github path", :vcr do
    fork = FactoryGirl.create(:fork, owner: 'batman', repo_name: 'batmobile')
    fork.github_path.should == 'https://github.com/batman/batmobile'
  end
  
  it "should set update frequency to nil when fork is disabled", :vcr do
    fork = FactoryGirl.create(:fork, owner: 'batman', repo_name: 'batmobile', active: "1", update_frequency: "daily")
    fork.active = "0"
    fork.save
    
    fork.update_frequency.should be_nil
  end
  
  it "should set the update frequency to daily when fork is initially enabled", :vcr do
    fork = FactoryGirl.create(:fork, owner: 'batman', repo_name: 'batmobile', active: "1")
    fork.update_frequency.should == "daily"
  end
  
  it "should remove the first select option for active forks", :vcr do
    fork = FactoryGirl.create(:fork, owner: 'batman', repo_name: 'batmobile', active: "1")
    fork.select_options.should == {'Daily' => 'daily', 'Weekly' => 'weekly', 'Monthly' => 'monthly'}
  end
  
  def count_prs(username,repo)
    pulls = Rails.application.github.pull_requests.list(username, repo)
    pulls.count
  end

  def close_pr(username, repo, number = nil)
    number ||= Rails.application.github.pull_requests.list(username, repo).first.number
    Rails.application.github.pull_requests.update(username, repo, number, state: 'closed')
  end

  it "should open a pull request from a parent to a fork", :vcr do
    fork = FactoryGirl.create(:fork, owner: 'Floppy', repo_name: 'such-travis')

    count_prs(fork.owner,fork.repo_name).should == 0

    # try to open the PR
    fork.generate_pr
    count_prs(fork.owner,fork.repo_name).should == 1

    # tidy up
    close_pr(fork.owner,fork.repo_name)

  end

  it "should not open a PR twice", :vcr do
    fork = FactoryGirl.create(:fork, owner: 'Floppy', repo_name: 'such-travis')

    count_prs(fork.owner,fork.repo_name).should == 0

    # try to open the PR
    fork.generate_pr
    count_prs(fork.owner,fork.repo_name).should == 1

    # open the PR again
    fork.generate_pr
    count_prs(fork.owner,fork.repo_name).should == 1

    # tidy up
    close_pr(fork.owner,fork.repo_name)
  end
  
  it "should enqueue a job on save", :vcr do
    Fork.any_instance.should_receive(:delay).once.and_call_original
    fork = FactoryGirl.create(:fork, owner: 'Floppy', repo_name: 'such-travis', active: true)
  end
  
  {
    'daily' => "1994-01-02T00:00",
    'weekly' => "1994-01-03T00:00",
    'monthly' => "1994-02-01T00:00",
  }.each_pair do |period, date|
    
    it "should enqueue job at #{date} for #{period} updates", :vcr do    
      Timecop.freeze(Time.local(1994)) # because THAT'S WHEN TIMECOP WAS SET
      Fork.any_instance.should_receive(:delay).with(run_at: DateTime.parse(date)).once.and_call_original
      fork = FactoryGirl.create(:fork, owner: 'Floppy', repo_name: 'such-travis', active: true, update_frequency: period)
      Timecop.return
    end
  end
  
end