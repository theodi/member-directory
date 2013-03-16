Feature: Sync from capsule
  In order to keep the member directory up to date
  As a member of the commercial team
  I want changes made in CapsuleCRM to propogate to the public directory
  
  Scenario: Create new memberships
    Given my organization name is "ACME Inc"
    And I am not currently a member
    When I am set as a member in CapsuleCRM
    And the sync task runs
    Then a membership should be created for me
    And my details should be cached correctly
    
  Scenario: Update existing memberships
    Given my organization name is "ACME Inc"
    And I am already signed up
    When my information is changed from CapsuleCRM
    And the sync task runs
    Then my details should be cached correctly
