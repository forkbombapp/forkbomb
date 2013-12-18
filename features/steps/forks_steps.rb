Then(/^I should be redirected to the repos page$/) do
  current_path.should == '/forks'
end

Then(/^I should see (.*?) forks under "(.*?)"$/) do |count, user|
  count = count.to_i
  count = count + 1 if count > 0 # header
  page.all("table.#{user} tr").count.should == count
end
