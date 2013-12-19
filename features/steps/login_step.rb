Given(/^my github username is "(.*?)"$/) do |username|
  @github_username = username
end

Given(/^I click login$/) do
  mock_login(@github_username)
  visit('/')
  click_link('Sign in')
end

Then(/^I should see a successful signin message$/) do
  page.should have_content('Successfully authenticated from Github account.')
end

Then(/^my username should be stored$/) do
  user = User.first
  user.github_username.should == @github_username
end

Given(/^I am logged in$/) do
  mock_login('foobar')
  visit('/')
  click_link('Sign in')
end

Given(/^I click log out$/) do
  click_link('Sign out')
end

Then(/^I should be logged out of the system$/) do
  page.should have_content('Signed out!')
end