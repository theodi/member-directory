Feature: Reset passwords

  As a member who has forgotten my password
  I want to reset my password
  So that I can get access to my account again

  Scenario: Reset password
    Given I am already signed up
    When I request a password reset
    Then I should receive a password reset email
    And I should be able to change my password
    
  Scenario: Reset password for users without size and sector
    Given I am already signed up
    But my size and sector are not set
    When I request a password reset
    Then I should receive a password reset email
    And I should be able to change my password