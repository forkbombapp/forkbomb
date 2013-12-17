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
  
end