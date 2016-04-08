Feature: Sync from capsule
  In order to keep the member directory up to date
  As a member of the commercial team
  I want changes made in CapsuleCRM to propogate to the public directory

  Scenario: Create new organization memberships
    Given I am not currently a member
    Then nothing should be placed on the signup queue
    But my membership number should be stored in CapsuleCRM
    When I am set as a member in CapsuleCRM
    And the sync task runs
    Then a membership should be created for me
    And that membership should not be shown in the directory
    And a welcome email should be sent to me
    And I should not see "Welcome Pack" in the email body
    And my details should be cached correctly
    When I follow "here" in the email
    Then I should see "Set your password"

  Scenario: Create new individual membership
    Given I am not currently an individual member
    Then nothing should be placed on the signup queue
    But my membership number should be stored in CapsuleCRM
    When I am set as a member in CapsuleCRM
    And the sync task runs
    Then an individual membership should be created for me
    And a welcome email should be sent to me
    When I follow "your member account" in the email
    Then I should see "Set your password"

  Scenario: Update existing organization memberships
    Given I am already signed up
    Then nothing should be placed on the queue
    When my information is changed in CapsuleCRM
    And the sync task runs
    Then my details should be cached correctly

  Scenario: Update existing individual memberships
    Given I am already signed up as an individual member
    Then nothing should be placed on the queue
    When my information is changed in CapsuleCRM
    And the sync task runs
    Then my individual details should be cached correctly

  Scenario: Notify if membership creation fails
    Given I am not currently a member
    Then nothing should be placed on the signup queue
    When I am set as a member in CapsuleCRM without an email address
    And the sync task runs it should raise an error
    Then a warning email should be sent to the commercial team
