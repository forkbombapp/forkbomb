@vcr
Feature: Manage forks
  
  As a user
  I want to be able to view and manage forks
  So I can keep them up to date
  
  Scenario: View forks
    Given my github username is "pezholio"
    And my github email is "pezholio@gmail.com"
    And I click login
    Then I should be redirected to the repos page
    And I should see 8 forks under "pezholio"
    And I should see 0 forks under "Lichfield-District-Council"
    And I should see 47 forks under "theodi"