Feature: Signup as an student member

  Background:
    Given I want to sign up as an student member
    And product information has been setup for "individual-supporter-student"
    When I visit the signup page

  Scenario: Signup as a student supporter
    When I enter my name and contact details
    And I enter my address details
    And I enter my university details
    Then I should not be asked for financial information
    And I should not be asked for organization details
    And I agree to the terms
    When I click sign up
    Then I am redirected to the payment page
    And I should have a membership number generated
    And I am processed through chargify for the "individual-supporter-student" option
    When I click complete
    And I am returned to the thanks page
    And I should see "Welcome to the ODI network!"
    And my student details should be saved
    And I should not have an organisation assigned to me
    And a welcome email should be sent to me
    And I should see "You’ve joined our network! Now what?" in the email subject
    And I should see "Dear Ian" in the email body
    And I should see "Welcome to the Open Data Institute" in the email body
    And my details should be queued for further processing
    When chargify verifies the payment

  @javascript
  Scenario: Auto-update terms based on user input
    Given I want to sign up as an student member
    When I visit the signup page
    And I enter my name and contact details
    And I enter my address details
    Then I should see "Your student membership"
    And I should see "means Ian McIain of 123 Fake Street, Faketown, United Kingdom, FAKE 123"
