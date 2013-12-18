Then(/^I should be redirected to the repos page$/) do
  current_path.should == '/fork'
end

Then(/^I should see (.*?) forks under "(.*?)"$/) do |count, user|
  page.all("ul.#{user} li").count.should == count.to_i
end
