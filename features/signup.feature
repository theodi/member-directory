@vcr
Feature: Add new signups to queue

  As a potential member, when I fill in my details, I want my details to be queued for further processing

  Scenario Outline: Member signup

    Given that I want to sign up as a <product_name>
    When I visit the signup page
    And I enter my details
    Then my details should be queued for further processing
    When I click sign up
    And I should have a membership number generated
    And a welcome email should be sent to me
    And I should see "Welcome Pack" in the email body

    Examples:
      | product_name |
      | supporter    |

	Scenario Outline: Member tries to sign up, but misses a mandatory field

    Given that I want to sign up
    When I visit the signup page
    And I enter my details
    But I leave <field> blank
    Then my details should not be queued
    When I click sign up
    And I should see an error relating to <text>

    Examples:
			| field 								| text             |
			| contact_name 					| Your Name        |
			| street_address 				| Address          |
			| address_locality 			| City             |
			| address_country 			| Country          |
			| postal_code 			    | Postcode         |
			
  Scenario: Member tries to sign up, but doesn't agree to the terms
  
    Given that I want to sign up
    When I visit the signup page
    And I enter my details
    But I don't agree to the terms
    Then my details should not be queued
    When I click sign up
    And I should get an error telling me to accept the terms
    
  Scenario: Member tries to sign up, but their password doesn't match
  
    Given that I want to sign up
    When I visit the signup page
    And I enter my details
    But my passwords don't match
    Then my details should not be queued
    When I click sign up
    And I should get an error telling my passwords don't match

  Scenario: Member tries to sign up, but enters an organization name that already exists
  
    Given that I want to sign up
    But there is already an organization with the name I want to use
    When I visit the signup page
    And I enter my details
    But I don't agree to the terms
    Then my details should not be queued
    When I click sign up
    And I should see an error relating to Organisation Name

  Scenario: Strip spaces from organisation names

    Given that I want to sign up as a supporter
    When I visit the signup page
    And I enter my details
    And my organisation name is "Doge Enterprises Inc. "
    Then my details should be queued for further processing
    When I click sign up
    And I should have a membership number generated
    And my organisation name should be "Doge Enterprises Inc."

  @javascript
  Scenario: Auto-update terms based on user input

    Given that I want to sign up as a supporter
    When I visit the signup page
    When I enter my details
    Then I should see "means FooBar Inc being"
    And I should see "with company number 012345678"
    And I should see "whose registered office is 123 Fake Street, Faketown, Fakeshire, UK, FAKE 123"
    And I should see "between FooBar Inc (“You” or “Your”)"
    And I should see today's date
  
  
  
