Feature: Signup and pay by invoice

  Background:
    Given that I want to sign up as a supporter
    And product information has been setup for "corporate-supporter_annual"

  Scenario: Member visits the signup page with invoice flag set
    When I visit the signup page with the invoice flag set
    Then the signup page should have a hidden field called "invoice"
    And the hidden field should have the value "1"
