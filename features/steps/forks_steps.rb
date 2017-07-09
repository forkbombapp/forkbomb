Then(/^I should be redirected to the repos page$/) do
  current_path.should == '/forks'
end

Then(/^I should see (.*?) forks under "(.*?)"$/) do |count, user|
  count = count.to_i
  count = count + 1 if count > 0 # header
  page.all("table.#{user} tr").count.should == count
end

When(/^I access the repos page$/) do
  visit('/forks')
end

Then(/^I should be redirected to the homepage$/) do
  current_path.should == '/'
end

Then(/^I should see a notice telling me to sign in$/) do
  page.should have_content('You must be logged in to access this page')
end

When(/^I click the slider for the repo "(.*?)" under the user "(.*?)"$/) do |repo, user|
  @repo = repo
  @user = user
  find("div[data-repo=#{user.downcase}-#{repo.downcase}]").click
  sleep 2
end

Then(/^the select box should be enabled$/) do
  find("select[data-repo=#{@user.downcase}-#{@repo.downcase}]")['disabled'].should == false
end

Then(/^the repo should be active$/) do
  Fork.where(:repo_name => @repo, :owner => @user).first.active.should == true
end

When(/^I set the repo update frequency to "(.*?)"$/) do |frequency|
  find("select[data-repo=#{@user.downcase}-#{@repo.downcase}]").find("option[value=#{frequency}]").select_option
  sleep 2
end

Then(/^the repo should have an update frequency of "(.*?)"$/) do |frequency|
  Fork.where(:repo_name => @repo, :owner => @user).first.update_frequency.should == frequency
end

Given(/^the repo "(.*?)" under the user "(.*?)" is enabled$/) do |repo, user|
  @user = user
  @repo = repo
  @fork = Fork.where(:repo_name => repo, :owner => user).first
  @fork.active = true
  @fork.save
end

Given(/^the repo has an update frequency of "(.*?)"$/) do |frequency|
  @fork.update_frequency = frequency
  @fork.save
end

Given(/^I click the slider for the repo$/) do
  find("div[data-repo=#{@user.downcase}-#{@repo.downcase}]").click
  sleep 5
end

Then(/^the repo should be inactive$/) do
  @fork.reload
  @fork.active.should == false
end

Then(/^the repo should have an update frequency of nil$/) do
  @fork.update_frequency.should == nil
end

Then(/^the select box should be disabled$/) do
  find("select[data-repo=#{@user.downcase}-#{@repo.downcase}]")['disabled'].should == true
end
