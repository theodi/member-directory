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
    And I enter my credit card details
    Then my details should be queued for further processing
    And my queued details should state that I have paid
    When I click sign up
    Then my card should be charged successfully
    And I should have a membership number generated
    And a welcome email should be sent to me
    And I should see "Welcome Pack" in the email body
