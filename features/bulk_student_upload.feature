Feature: Signup as an student member

  Background:
    Given I am logged in as an administrator
    And I visit the student bulk upload page

  Scenario: Download a template CSV file
    When I click "Download template CSV"
    Then I should receive a CSV file called "template.csv"
    And that CSV file should contain columns for all student signup fields
    And that CSV should have an example line.