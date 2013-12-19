require 'spec_helper'

describe Fork do
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
  
  it "should generate a param", :vcr do 
    fork = FactoryGirl.create(:fork, user: 'batman', repo_name: 'batmobile')
    fork.to_param.should == "batman/batmobile"
  end
  
  it "should find forks by repo path", :vcr do
    fork = FactoryGirl.create(:fork, user: 'batman', repo_name: 'batmobile')
    repo = Fork.find_by_repo_path('batman/batmobile')
    repo.user.should == 'batman'
    repo.repo_name.should == 'batmobile'
  end
  
  it "should generate a github path", :vcr do
    fork = FactoryGirl.create(:fork, user: 'batman', repo_name: 'batmobile')
    fork.github_path.should == 'https://github.com/batman/batmobile'
  end
  
  it "should set update frequency to nil when fork is disabled", :vcr do
    fork = FactoryGirl.create(:fork, user: 'batman', repo_name: 'batmobile', active: "1", update_frequency: "daily")
    fork.active = "0"
    fork.save
    
    fork.update_frequency.should be_nil
  end
  
  it "should set the update frequency to daily when fork is initially enabled", :vcr do
    fork = FactoryGirl.create(:fork, user: 'batman', repo_name: 'batmobile', active: "1")
    fork.update_frequency.should == "daily"
  end
end