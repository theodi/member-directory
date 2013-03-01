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

    Examples:
      | product_name |
      | supporter    |
      | member       |

  Scenario: Invalid product signup
  
    Given that I want to sign up as a spaceman
    When I visit the signup page
    And I enter my details
    Then my details should not be queued
    When I click sign up
    And I should see that the membership level is invalid

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
			| contact_name 					| Your Name     |
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
