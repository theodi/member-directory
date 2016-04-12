Feature: Signup as a supporter member
  As a potential member
  When I fill in my details and those of my organization
  I want my payment to be processed by chargify and sent in the background to capsule

  Background:
    Given that I want to sign up as a supporter
    And product information has been setup for "corporate-supporter_annual"
    When I visit the signup page

  Scenario: Member signup
    When I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
    When I click sign up
    Then I am redirected to the payment page
    And I should have a membership number generated
    And I am processed through chargify for the "corporate-supporter_annual" option
    When I click pay now
    And I am returned to the thanks page
    And I should see "Thanks for supporting The ODI"
    And a welcome email should be sent to me
    And I should see "Welcome to the ODI network!" in the email subject
    And I should see "Welcome Pack" in the email body
    And my details should be queued for further processing
    When chargify verifies the payment

  Scenario: Monthly paying member signup
    Given product information has been setup for "supporter_annual"
    And product information has been setup for "supporter_monthly"
    When I enter my name and contact details
    And I enter my non-profit organization details
    And I enter my address details
    And I agree to the terms
    When I click sign up
    Then I am redirected to the payment page
    And there are payment frequency options
    And I choose to pay "payment_frequency_monthly"
    And I am processed through chargify for the "supporter_monthly" option
    When I click pay now

  Scenario: Member signup with origin
    When I visit the signup page with an origin of "odi-leeds"
    And I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
    When I click sign up
    Then I should have an origin of "odi-leeds"

  Scenario: Coupon discount codes
    When I visit the signup page with a coupon of "ODIALUMNI"
    And I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
    When I click sign up
    Then I am redirected to the payment page
    And I am processed through chargify for the "corporate-supporter_annual" option
    And the coupon code "ODIALUMNI" is saved against my membership
    When I click pay now
    And I am returned to the thanks page
    And my details should be queued for further processing
    When chargify verifies the payment

  Scenario Outline: Member tries to sign up, but misses a mandatory field
    When I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
    But I leave <field> blank
    When I click sign up
    And I should see an error relating to <text>

    Examples:
      | field                 | text              |
      | contact_name          | Full name         |
      | street_address        | Address           |
      | address_region        | Town or city      |
      | address_country       | Country           |
      | postal_code           | Postcode          |
      | organization_size     | Organisation size |
      | organization_type     | Organisation type |
      | organization_sector   | Industry sector   |

  Scenario: Member tries to sign up, but doesn't agree to the terms
    When I enter my name and contact details
    And I enter my company details
    And I enter my address details
    But I don't agree to the terms
    When I click sign up
    Then I should get an error telling me to accept the terms

  Scenario: Member tries to sign up, but their password doesn't match
    When I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
    But my passwords don't match
    When I click sign up
    Then I should get an error telling my passwords don't match

  Scenario: Member tries to sign up, but enters an organization name that already exists
    When I enter my name and contact details
    And I enter my company details
    But there is already an organization with the name I want to use
    And I enter my address details
    And I agree to the terms
    When I click sign up
    Then I should see an error relating to Organisation name

  Scenario: Member abandons signup before chargify processes, and returns to sign up again
    Given I have signed up, but haven't paid
    And I should have a membership number generated
    And I try to sign up again
    Then I am redirected to the payment page
    And I am processed through chargify for the "corporate-supporter_annual" option
    When I click pay now
    And I am returned to the thanks page
    And a welcome email should be sent to me
    And I should see "Welcome Pack" in the email body
    And my details should be queued for further processing
    When chargify verifies the payment

  Scenario: User tries to sign up with an email that has an abandonned account, but passwords don't match
    Given there is an abandoned account with the email "test@foo.bar" and the password "p4ssw0rd"
    And I try to sign up with the email "test@foo.bar" and the password "s3cr3tc0d3z"
    When I click sign up
    Then I should be redirected to the login page
    And I should see an error telling me I need to login
    And I log in
    Then I am redirected to the payment page
    And I am processed through chargify for the "corporate-supporter_annual" option
    When I click pay now
    And I am returned to the thanks page
    And a welcome email should be sent to me
    And I should see "Welcome Pack" in the email body
    And my details should be queued for further processing
    When chargify verifies the payment

  Scenario: Member signs up and changes payment method half way through
    When I enter my name and contact details
    And I enter my company details
    And I enter my address details
    And I agree to the terms
    When I click sign up
    Then I am redirected to the payment page
    And I should have a membership number generated
    And I realise that I want to pay by invoice
    And I follow the pay by invoice link
    Then I am returned to the thanks page
    And a welcome email should be sent to me

  @javascript
  Scenario: Auto-update terms based on user input
    When I enter my name and contact details
    And I enter my company details
    And I enter my address details
    Then I should see "means FooBar Inc being"
    And I should see "with number 012345678"
    And I should see "whose principal address is 123 Fake Street, Faketown, United Kingdom, FAKE 123"
    And I should see "£720 per annum + VAT for SME & Non Profit Supporters"
    And I should see "or £2,200 per annum + VAT for Corporate Supporters"
