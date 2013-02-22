@vcr
Feature: Add new signups to queue

  As a potential member, when I fill in my details, I want my details to be queued for further processing
  
  Scenario: Supporter signup
  
    Given that I want to sign up as a supporter
    When I visit the signup page
    And I enter my details
    Then my details should be queued for further processing
    When I click sign up
    
  Scenario: Member signup
  
    Given that I want to sign up as a member
    When I visit the signup page
    And I enter my details
    Then my details should be queued for further processing
    When I click sign up

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
			| level 								| Level            |
			| contact_name 					| Contact name     |
			| address_line1 				| Address line1    |
			| address_city 					| Address city     |
			| address_country 			| Address country  |
			| address_postcode 			| Address postcode |
			
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
    And I should get an error telling me my passwords don't match