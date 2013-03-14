Feature: Uploading member logos to directory

  As a member I want to be able to upload my organisations logo so it can be displayed in the member directory

  Scenario: Successful logo upload to rackspace from file

    Given that I have signed up as a member
    And I am redirected to submit my organization details
    And I can see a logo upload
    And my organisations logo is in the file "fixtures/image_object_uploader/acme-logo.png"
    When I upload my organisations logo from a local file
    Then it should be stored in the container named "theodi-members-logos" with CDN URI "http://3c15e477272a919c85ab-3fbe4c8744736fb7318f7d4ea2dff54a.r10.cf3.rackcdn.com"
    Then the fullsize logo should be available at the URL "http://3c15e477272a919c85ab-3fbe4c8744736fb7318f7d4ea2dff54a.r10.cf3.rackcdn.com/xy9876za-logo.png"
    And the logo thumbnail should be available at the URL "http://3c15e477272a919c85ab-3fbe4c8744736fb7318f7d4ea2dff54a.r10.cf3.rackcdn.com/xy9876za-logo-thumbnail.png"