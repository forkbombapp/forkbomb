@vcr @javascript
Feature: Manage forks
  
  As a user
  I want to be able to view and manage forks
  So I can keep them up to date
  
  Background: 
    Given my github username is "pezholio"
    And I click login
  
  Scenario: View forks
    When I access the repos page
    Then I should see 8 forks under "pezholio"
    And I should see 0 forks under "Lichfield-District-Council"
    And I should see 47 forks under "theodi"
    
  Scenario: Non-logged in user tries to access forks page
    When I click log out
    And I access the repos page
    Then I should be redirected to the homepage
    And I should see a notice telling me to sign in
    
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
    
  Scenario: Disable fork
    Given I access the repos page
    And the repo "Better-Countdown" under the user "pezholio" is enabled
    And the repo has an update frequency of "daily"
    And I access the repos page
    And I click the slider for the repo
    Then the repo should be inactive
    And the repo should have an update frequency of nil
    And the select box should be disabled
    