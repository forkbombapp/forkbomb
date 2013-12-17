Given(/^my github email is "(.*?)"$/) do |email|
  @github_email = email
end

Given(/^my github username is "(.*?)"$/) do |username|
  @github_username = username
end

Given(/^I click login$/) do
  mock_login(@github_email, @github_username)
  visit('/')
  click_link('Sign in')
end

Then(/^I should see a successful signin message$/) do
  page.should have_content('Successfully authenticated from Github account.')
end

Then(/^my email and username should be stored$/) do
  user = User.first
  user.email.should == @github_email
  user.github_username.should == @github_username
end