@vcr @javascript
Feature: Manage forks
  
  As a user
  I want to be able to view and manage forks
  So I can keep them up to date
  
  Background: 
    Given my github username is "pezholio"
    And my github email is "pezholio@gmail.com"
    And I click login
  
  Scenario: View forks
    When I access the repos page
    Then I should see 8 forks under "pezholio"
    And I should see 0 forks under "Lichfield-District-Council"
    And I should see 47 forks under "theodi"
    
  Scenario: Set fork status
    When I access the repos page
    And I click the slider for the repo "Better-Countdown" under the user "pezholio"
    Then the select box should be enabled
    And the repo should be active
    
  Scenario: Set fork update frequency
    When I access the repos page
    And I click the slider for the repo "Better-Countdown" under the user "pezholio"
    And I set the repo update frequency to "daily"
    Then the repo should be active
    And the repo should have an update frequency of "daily"