Feature: Add new signups to queue

  As a potential member, when I fill in my details, I want my details to be queued for further processing

  Scenario Outline: Member signup

    Given that I want to sign up as a <product_name>
    When I visit the signup page
    And I enter my details
    And I choose to pay by invoice
    Then my details should be queued for further processing
    When I click sign up
    And I should have a membership number generated
    And a welcome email should be sent to me
    And I should see "Welcome Pack" in the email body

    Examples:
      | product_name |
      | supporter    |

  Scenario: Member signs up but does not choose a payment method

    Given that I want to sign up
    When I visit the signup page
    And I enter my details
    Then my details should not be queued
    When I click sign up
    And I should see an error relating to Payment method

  Scenario Outline: Member tries to sign up, but misses a mandatory field

    Given that I want to sign up
    When I visit the signup page
    And I enter my details
    And I choose to pay by invoice
    But I leave <field> blank
    Then my details should not be queued
    When I click sign up
    And I should see an error relating to <text>

    Examples:
			| field 								| text             |
			| contact_name 					| Your Name        |
			| street_address 				| Address          |
			| address_locality 			| City             |
			| postal_code 			    | Postcode         |
      | organization_size     | Organisation size |
      | organization_type     | Organisation type |
#			| address_country 			| Country          |

  Scenario: Member tries to sign up, but doesn't agree to the terms

    Given that I want to sign up
    When I visit the signup page
    And I enter my details
    And I choose to pay by invoice
    But I don't agree to the terms
    Then my details should not be queued
    When I click sign up
    And I should get an error telling me to accept the terms

  Scenario: Member tries to sign up, but their password doesn't match

    Given that I want to sign up
    When I visit the signup page
    And I enter my details
    And I choose to pay by invoice
    But my passwords don't match
    Then my details should not be queued
    When I click sign up
    And I should get an error telling my passwords don't match

  Scenario: Member tries to sign up, but enters an organization name that already exists

    Given that I want to sign up
    But there is already an organization with the name I want to use
    When I visit the signup page
    And I enter my details
    And I choose to pay by invoice
    But I don't agree to the terms
    Then my details should not be queued
    When I click sign up
    And I should see an error relating to Organisation Name

  Scenario: Strip spaces from organisation names

    Given that I want to sign up as a supporter
    When I visit the signup page
    And I enter my details
    And I choose to pay by invoice
    And my organisation name is "Doge Enterprises Inc. "
    Then my details should be queued for further processing
    When I click sign up
    And I should have a membership number generated
    And my organisation name should be "Doge Enterprises Inc."

  @javascript
  Scenario: Auto-update terms based on user input

    Given that I want to sign up as a supporter
    When I visit the signup page
    When I choose to pay by invoice
    And I enter my details
    Then I should see "means FooBar Inc being"
    And I should see "with company number 012345678"
    And I should see "whose registered office is 123 Fake Street, Faketown, Fakeshire, United Kingdom, FAKE 123"
    And I should see "between FooBar Inc (“You” or “Your”)"
    And I should see "£720 per annum for commercial organisations with 249 employees or fewer"
    And I should see "or £2,200 per annum for commercial organisations with 250 employees or more"
    And I should see today's date
