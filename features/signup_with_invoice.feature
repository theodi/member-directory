Feature: Signup and pay by invoice

  Background:
    Given that I want to sign up as a supporter
    And product information has been setup for "corporate-supporter_annual"

  Scenario: Member visits the signup page with invoice flag set
    When I visit the signup page with the invoice flag set
    Then the signup page should have a hidden field called "invoice"
    And the hidden field should have the value "1"

  Scenario: Member signing up with invoice does not get redirected to chargify
    When I visit the signup page with the invoice flag set
    And I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
    Then my organization should be made active in Capsule
    Then my details should be queued for further processing
    When I click sign up
    Then I am returned to the thanks page
    And I should have a membership number generated
    And a welcome email should be sent to me
    And I should be marked as active

  Scenario: Individual member setting invoice flag does not get redirected to Chargify
    Given I want to sign up as an individual member
    And product information has been setup for "individual-supporter"
    When I visit the signup page with the invoice flag set
    When I enter my name and contact details
    And I enter my address details
    And I enter my subscription amount
    And I agree to the terms
    When I click sign up
    And I am returned to the thanks page

  Scenario: Member signing up with invoice retains invoive flag on redirect
    When I visit the signup page with the invoice flag set
    And I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
    But I leave contact_name blank
    And I click sign up
    Then I should see an error relating to Full name
    And I enter my name and contact details
    Then my organization should be made active in Capsule
    Then my details should be queued for further processing
    When I click sign up
    And I am returned to the thanks page
    And I should have a membership number generated
    And a welcome email should be sent to me
    And I should be marked as active
