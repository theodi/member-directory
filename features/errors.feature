Feature: Custom error pages
  In order to understand why something went wrong
  As a member
  I want to see a helpful error page, not the rails default
  
  @allow-rescue
  Scenario: 404 page
    When I request a page that doesn't exist
    Then I should see a helpful error page
    And the response status should be "404"