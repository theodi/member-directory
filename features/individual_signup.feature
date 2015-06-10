Feature: Signup as an individual member

  Background:
    Given I want to sign up as an individual member
    And product information has been setup for "individual-supporter"
    When I visit the signup page

  Scenario: Individual member signup

    When I enter my name and contact details
    And I enter my address details
    And I agree to the terms
    When I click sign up
    Then I am redirected to the payment page
    And I should have a membership number generated
    And I am processed through chargify for the "individual-supporter" option
    When I click pay now
    And I am returned to the thanks page
    And I should not have an organisation assigned to me
    And a welcome email should be sent to me
    And I should see "We are delighted to welcome you to the Open Data Institute member network" in the email body
    And I should see "download an ODI Supporter badge" in the email body
    And my details should be queued for further processing
    When chargify verifies the payment

  Scenario: Individual member does not see specific fields

    Then I should not see the "Organisation Name" field
    And I should not see the "Organisation size" field
    And I should not see the "Organisation type" field
    And I should not see the "Industry sector" field
    And I should not see the "Company Number" field
    And I should not see the "VAT Number (if not UK)" field
    And I should not see the "Purchase Order Number" field
    And the terms and conditions should be correct
    And the submit button should say "Become an ODI member"
    And I should see a link to the right to cancel

  @javascript
  Scenario: Auto-update terms based on user input

    Given I want to sign up as an individual member
    When I visit the signup page
    And I enter my name and contact details
    And I enter my address details
    Then I should see "You agree to comply with these terms and conditions"
    And I should see "means Ian McIain of 123 Fake Street, Faketown, Fakeshire, United Kingdom, FAKE 123"
