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
    
    Examples:
    | level   |
    | partner |
    | sponsor |