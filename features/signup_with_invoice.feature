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
    When I click sign up
    Then I am returned to the thanks page
    And I should have a membership number generated

  Scenario: Individual member setting invoice flag still gets redirected to chargify
    Given I want to sign up as an individual member
    And product information has been setup for "individual-supporter"
    When I visit the signup page with the invoice flag set
    When I enter my name and contact details
    And I enter my address details
    And I agree to the terms
    When I click sign up
    Then I am redirected to the payment page
