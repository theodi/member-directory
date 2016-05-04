Feature: Signup as an individual member

  Background:
    Given I want to sign up as an individual member
    And product information has been setup for "individual-supporter-new"
    When I visit the signup page

  Scenario: Individual member signup
    When I enter my name and contact details
    And I enter my address details
    And I enter my subscription amount
    And I agree to the terms
    When I click sign up
    Then I am redirected to the payment page
    And I should have a membership number generated
    And I am processed through chargify for the "individual-supporter-new" option
    When I click pay now
    And I am returned to the thanks page
    And I should see "Thanks for supporting The ODI"
    And I should not have an organisation assigned to me
    And a welcome email should be sent to me
    And I should see "Congratulations! You’ve joined the open data revolution." in the email subject
    And I should see "Welcome to the Open Data Institute (ODI) member network!" in the email body
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
    And I should not see the student specific fields

  Scenario: Member signup with an affiliated node
    Given that I want to sign up as an individual supporter
    When I visit the signup page
    Then I should see an affiliated node section

  Scenario: Member signup with an affiliated node and origin
    Given that I want to sign up as an individual supporter
    When I visit the signup page with an origin of "odi-leeds"
    Then I should see an affiliated node section
    And the dropdown should be pre-selected with "odi-leeds"
    And if I navigate away and then return
    Then the original origin value should be still be "odi-leeds"

  Scenario: Signup with coupon should not see amount dropdown
    Given that I want to sign up as an individual supporter
    And the coupon code SUPERFREE is in Chargify
    When I visit the signup page with an coupon code of "SUPERFREE"
    Then I should not see the subscription amount
    When I enter my name and contact details
    And I enter my address details
    And I agree to the terms
    When I click sign up
    Then I am redirected to the payment page
    And I should have a membership number generated
    And I am processed through chargify for the "individual-pay-what-you-like-free" option
    When I click complete
