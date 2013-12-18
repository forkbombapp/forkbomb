Then(/^I should be redirected to the repos page$/) do
  current_path.should == '/fork'
end

Then(/^I should see (.*?) forks under "(.*?)"$/) do |count, user|
  count = count.to_i
  count = count + 1 if count > 0 # header
  page.all("table.#{user} tr").count.should == count
end

When(/^I access the repos page$/) do
  visit('/fork')
end

When(/^I click the slider for the repo "(.*?)" under the user "(.*?)"$/) do |repo, user|
  @repo = repo
  @user = user
  find("div[data-repo=#{user.downcase}-#{repo.downcase}]").click
end

Then(/^the select box should be enabled$/) do
  find("select[data-repo=#{@user.downcase}-#{@repo.downcase}]")['disabled'].should == nil
end

Then(/^the repo should be active$/) do
  Fork.where(:repo_name => @repo, :user => @user).first.active.should == true
end

When(/^I set the repo update frequency to "(.*?)"$/) do |frequency|
  find("select[data-repo=#{@user.downcase}-#{@repo.downcase}]").find("option[value=#{frequency}]").select_option
  sleep 2
end

Then(/^the repo should have an update frequency of "(.*?)"$/) do |frequency|
  Fork.where(:repo_name => @repo, :user => @user).first.update_frequency.should == frequency
end