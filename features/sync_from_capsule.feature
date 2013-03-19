Feature: Sync from capsule
  In order to keep the member directory up to date
  As a member of the commercial team
  I want changes made in CapsuleCRM to propogate to the public directory
  
  Scenario: Create new memberships
    Given I am not currently a member
    Then nothing should be placed on the signup queue
    But my membership number should be stored in CapsuleCRM
    When I am set as a member in CapsuleCRM
    And the sync task runs
    Then a membership should be created for me
    And that membership should not be shown in the directory
    And my details should be cached correctly

  Scenario: Update existing memberships
    Given I am already signed up
    Then nothing should be placed on the queue
    When my information is changed in CapsuleCRM
    And the sync task runs
    Then my details should be cached correctly
