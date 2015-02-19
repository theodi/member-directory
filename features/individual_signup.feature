Feature: Signup as an individual member

  Background:
    Given chargify has a registered product for the "individual_supporter" plan

  Scenario: Individual member does not see specific fields

    Given I want to sign up as an individual member
    When I visit the signup page
    Then I should not see the "Organisation Name" field
    And I should not see the "Organisation size" field
    And I should not see the "Organisation type" field
    And I should not see the "Industry sector" field
    And I should not see the "Company Number" field
    And I should not see the "VAT Number (if not UK)" field
    And I should not see the "Purchase Order Number" field
    And the terms and conditions should be correct
    And the submit button should say "Become an ODI member"

  @javascript
  Scenario: Auto-update terms based on user input

    Given I want to sign up as an individual member
    When I visit the signup page
    And I enter my name and contact details
    Then I should see "You agree to comply with these terms and conditions"
    And I should see "means Ian McIain of (address)"

  Scenario: Member signup

    Given I want to sign up as an individual member
    When I visit the signup page
    And I enter my name and contact details
    And I should see a link to the right to cancel
    When I click sign up
    Then I pay via chargify and return to the member page
    And I should have a membership number generated
    And I should see my details
    And a welcome email should be sent to me
    And I should see "download an ODI Supporter badge" in the email body

  Scenario: Individual members should not have an organisation assigned

    Given I want to sign up as an individual member
    When I visit the signup page
    And I enter my name and contact details
    When I click sign up
    Then I pay via chargify and return to the member page
    And I should not have an organisation assinged to me
