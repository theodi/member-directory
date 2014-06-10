@vcr
Feature: Accept credit card payments during signup

  As a potential member
  When I sign up
  Then I want to be able to choose to pay by credit card immediately

  Scenario: Member signup

    Given that I want to sign up as a supporter
    When I visit the signup page
    And I enter my details
    And I choose to pay by credit card
    And I enter valid credit card details
    Then my details should be queued for further processing
    When I click sign up
    Then my card should be charged successfully
    And I should have a membership number generated
    And a welcome email should be sent to me
    And I should see "Welcome Pack" in the email body

  Scenario: Bad credit card details

    Given that I want to sign up as a supporter
    When I visit the signup page
    And I enter my details
    And I choose to pay by credit card
    And I enter invalid credit card details
    Then my details should not be queued
    When I click sign up
    Then my card should not be charged
    And I should see an error relating to "credit card"
