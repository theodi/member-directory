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

  Scenario Outline: Bad credit card details

    Given that I want to sign up as a supporter
    When I visit the signup page
    And I enter my details
    And I choose to pay by credit card
    And I enter my card number <card_number>
    And I enter my CVC code <cvc>
    And I enter my expiry month <month>
    And I enter my expiry year <year>
    Then my details should not be queued
    When I click sign up
    And I should see an error relating to <error>

    Examples:
      | card_number      | cvc | month | year | error                        |
      | 4242424242424241 | 123 | 12    | 2016 | Card number                  |
      | 4000000000000127 | 123 | 12    | 2016 | Card validation code         |
      | 1234             | 123 | 12    | 2016 | Card number                  |
      | 4242424242424242 | 123 | 13    | 2016 | Card expiry month            |
      | 4242424242424242 | 123 | 12    | 1970 | Card expiry year             |
      | 4242424242424242 | 1   | 12    | 2016 | Card validation code         |
      | 4000000000000069 | 123 | 12    | 2016 | Card number has expired      |
      | 4000000000000002 | 123 | 12    | 2016 | Card number has been declined|
