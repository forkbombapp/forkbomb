Feature: Github login

  As a user
  I would like to login using GitHub
  So I can access my repos
  
  Scenario: Github Login
    Given my github email is "hello@example.com"
    And I click login
    Then I should see a successful signin message
    And my email should exist in the database