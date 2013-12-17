require 'spec_helper'

describe "PullRequester", :vcr do
  
  def count_prs(username,repo)
    pulls = Rails.application.github.pull_requests.list(username, repo)
    pulls.count
  end

  def close_pr(username, repo, number = nil)
    number ||= Rails.application.github.pull_requests.list(username, repo).first.number
    Rails.application.github.pull_requests.update(username, repo, number, state: 'closed')
  end

  it "should open a pull request from a parent to a fork" do

    username = 'Floppy'
    repo = 'such-travis'

    count_prs(username,repo).should == 0

    # try to open the PR
    PullRequester.perform(username, repo)
    count_prs(username,repo).should == 1

    # tidy up
    close_pr(username, repo)

  end

  it "should not open a PR twice" do

    username = 'Floppy'
    repo = 'such-travis'

    count_prs(username,repo).should == 0

    # try to open the PR
    PullRequester.perform(username, repo)
    count_prs(username,repo).should == 1

    # open the PR again
    PullRequester.perform(username, repo)
    count_prs(username,repo).should == 1

    # tidy up
    close_pr(username, repo)

  end

end