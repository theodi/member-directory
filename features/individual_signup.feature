Feature: Signup as an individual member

  Scenario: Individual member does not see specific fields

    Given I want to sign up as an individual member
    When I visit the signup page
    Then I should not see the "Organisation Name" field
    And I should not see the "Organisation size" field
    And I should not see the "Company Number" field
    And I should not see the "VAT Number (if not UK)" field
    And I should not see the "Purchase Order Number" field
    And the terms and conditions should be correct

  @javascript
  Scenario: Auto-update terms based on user input

    Given I want to sign up as an individual member
    When I visit the signup page
    And I enter my details
    Then I should see "This Agreement is made between Ian McIain"
    And I should see "means Ian McIain of 123 Fake Street, Faketown, Fakeshire, United Kingdom, FAKE 123"
    And I should see today's date