Given(/^my github email is "(.*?)"$/) do |email|
  @github_email = email
end

Given(/^I click login$/) do
  visit('/')
  click_link('Sign in with Github')
end

Then(/^I should see a successful signin message$/) do
  page.should have_content('Successfully authenticated from Github account.')
end

Then(/^my email should exist in the database$/) do
  User.find_by_email(@github_email).count.should == 1
end