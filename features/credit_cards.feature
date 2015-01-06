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

  Scenario: Member signup with bad data

    Given that I want to sign up as a supporter
    When I visit the signup page
    And I enter my details
    And I choose to pay by credit card
    And I enter valid credit card details
    But I leave street_address blank
    Then my details should not be queued
    And credit card payment shouldn't be attempted
    When I click sign up

  Scenario Outline: Correct amount should be charged

    Given that I want to sign up as a supporter
    When I visit the signup page
    And I enter my details
    And I enter an organisation size of <size>
    And I enter an organisation type of <type>
    And I choose to pay by credit card
    And I enter valid credit card details
    And I choose to pay on a <frequency> basis
    And I click sign up
    Then I should be signed up to the <plan> plan

      Examples:
        | size     | type            | frequency | plan                             |
        | <10      | non_commercial  | monthly   | supporter_monthly                |
        | 251-1000 | non_commercial  | monthly   | supporter_monthly                |
        | 10-50    | commercial      | monthly   | supporter_monthly                |
        | 251-1000 | commercial      | monthly   | 2015_corporate_supporter_monthly |
        | 51-250   | non_commercial  | annual    | supporter_annual                 |
        | >1000    | non_commercial  | annual    | supporter_annual                 |
        | 51-250   | commercial      | annual    | supporter_annual                 |
        | >1000    | commercial      | annual    | 2015_corporate_supporter_annual  |

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
      | 4000000000000127 | 123 | 12    | 2016 | CVC                          |
      | 1234             | 123 | 12    | 2016 | Card number                  |
      | 4242424242424242 | 123 | 13    | 2016 | Expiry month                 |
      | 4242424242424242 | 123 | 12    | 1970 | Expiry year                  |
      | 4242424242424242 | 1   | 12    | 2016 | CVC                          |
      | 4000000000000069 | 123 | 12    | 2016 | Card number has expired      |
      | 4000000000000002 | 123 | 12    | 2016 | Card number has been declined|
