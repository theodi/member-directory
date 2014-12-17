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
    And the submit button should say "Pay now"

  @javascript
  Scenario: Auto-update terms based on user input

    Given I want to sign up as an individual member
    When I visit the signup page
    And I enter my details
    And I agree to the data protection policy
    Then I should see "This Agreement is made between Ian McIain"
    And I should see "means Ian McIain of 123 Fake Street, Faketown, Fakeshire, United Kingdom, FAKE 123"
    And I should see today's date

  @vcr
  Scenario: Member signup

    Given I want to sign up as an individual member
    When I visit the signup page
    And I enter my details
    And I enter valid credit card details
    And I agree to the data protection policy
    And I should see a link to the right to cancel
    Then my details should be queued for further processing
    When I click sign up
    Then my card should be charged successfully
    And I should have a membership number generated
    And I should see my details
    And a welcome email should be sent to me
    And I should see "download an ODI Supporter badge" in the email body

  @vcr
  Scenario: Individual members should not have an organisation assigned

    Given I want to sign up as an individual member
    When I visit the signup page
    And I enter my details
    And I enter valid credit card details
    And I agree to the data protection policy
    And I click sign up
    Then I should not have an organisation assinged to me

  Scenario: Indivudial member tries to sign up, but doesn't agree to the data protection policy

    Given I want to sign up as an individual member
    When I visit the signup page
    And I enter my details
    And I enter valid credit card details
    When I click sign up
    And I should get an error telling me to accept the data protection policy
