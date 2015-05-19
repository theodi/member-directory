Feature: Sign in to the member directory

  As a member, I need to sign in to the system to modify my account details

  Scenario: Successful signin

    Given that I have a membership number and password
    When I visit the sign in page
    And I enter my membership number and password
    And the password is correct
    When I click sign in
    Then I should have signed in successfully

  Scenario: Successful signin with email

    Given that I have a membership number and password
    When I visit the sign in page
    And I enter my email address and password
    And the password is correct
    When I click sign in
    Then I should have signed in successfully

  Scenario: Incorrect password

    Given that I have a membership number and password
    When I visit the sign in page
    And I enter my membership number and password
    And the password is incorrect
    When I click sign in
    Then I should have recieve an error

  Scenario: Incorrect membership number

    Given that I have a membership number and password
    When I visit the sign in page
    And I enter my membership number and password
    And the membership number is incorrect
    When I click sign in
    Then I should have recieve an error
