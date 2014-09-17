@timecop
Feature: Editing membership details

  As a member, I want to update my details

  Scenario: Supporter updates their contact details

    Given I have a sponsor account
    And I visit my account page
    And I enter my organization details
    And I update my membership details
    Then my membership details should be queued for updating in CapsuleCRM
    And my organisation details should be queued for further processing
    When I click submit
    And I should see a notice that my details were saved successfully
    And I should see my changed membership details when I revisit the edit page
