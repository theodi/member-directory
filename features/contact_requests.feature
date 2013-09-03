Feature: Send a contact request
  As a person interested in becoming a high-level member of the ODI
  I want to fill in a contact form
  So that someone will get in touch with me to discuss my interest

  Scenario Outline: fill in contact form
    
    Given that I want to sign up as a <level>
    When I visit the contact page
    And I enter my request details
    Then my request should be queued for further processing
    When I click contact me
    Then I should see "Thank you for getting in touch. We'll give you a call soon to discuss how we can work together."
    
    Examples:
    | level   |
    | partner |
    | sponsor |
    
    
	Scenario Outline: Enquirer tries to get in touch, but misses a mandatory field

    Given that I want to sign up as a partner
    When I visit the contact page
    And I enter my request details
    But I leave <field> blank
    Then my details should not be queued
    When I click contact me
    And I should see an error relating to <text>

    Examples:
    | field 								| text             |
    | person_name           | Name             |
    | person_affiliation    | Organisation     |
    | person_email          | Email Address    |
    | person_telephone      | Telephone Number |
    | person_job_title      | Job Title        |
    | comment_text          | Your Interest    |
    
  Scenario: Enquirer tries to get in touch, but ticks the honeypot box
  
    Given that I want to sign up as a partner
    When I visit the contact page
    And I enter my request details
    But I tick the honeypot box
    Then my details should not be queued
    When I click contact me
    And I should see an error relating to Honeypot    