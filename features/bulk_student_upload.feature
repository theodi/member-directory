Feature: Bulk upload of student members

  Background:
    Given I am logged in as an administrator
    And I visit the student bulk upload page
    And the student coupon code SUPERFREE is in Chargify

  Scenario: Download a template CSV file
    When I click "Download template CSV"
    Then I should receive a CSV file called "sample.csv"
    And that CSV file should contain columns for all student signup fields
    And that CSV should have an example line.
    
  Scenario: Upload a CSV file full of students
    When I select the file "upload/students.csv" for upload
    And that file contains a set of student details
    Then their details should be queued for adding to Chargify
    And their details should be queued for further processing
    When I click "Upload"
    Then I should see the results of my upload
    And I should see "Bob Fish <bob@example.edu>"
    And a student membership should be created for "bob@example.edu"
    And a welcome email should be sent to "bob@example.edu"
    And they should see "To activate your account" in the email body
    When they follow "here" in the email
    Then they should see "Set your password"
    And after the chargify job has run
    Then that member should be set up in Chargify
