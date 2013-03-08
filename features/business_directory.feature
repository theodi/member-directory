Feature: Adding details to the organization directory

	As a member, I want my details to be listed on the organization directory and stored in capsule

	Scenario: Sucessful organization directory upload
			
		Given that I want to sign up
		When I visit the signup page
		And I enter my details
		And I click sign up
		Then I am redirected to submit my organization details
		And I enter my organization details
		Then my details should be updated in CapsuleCRM
		When I click submit
			
	Scenario Outline: User tries to submit their details, but misses a mandatory field
		
		Given that I want to sign up
		When I visit the signup page
		And I enter my details
		And I click sign up
		Then I am redirected to submit my organization details
		And I enter my organization details
		But I leave my organization <field> blank
		Then my details should not be updated in CapsuleCRM
		When I click submit
		And I should see an error relating to <text>
			
		Examples:
			| field       | text         |
			| name        | Name		     |
			| description | Description  |
      
      
  Scenario Outline: User submits bad URLs
  
		Given that I want to sign up
		When I visit the signup page
		And I enter my details
		And I click sign up
		Then I am redirected to submit my organization details
		And I enter my organization details
		But I enter the URL <url>
		When I click submit
		Then I should <outcome>
			
		Examples:
      | url                    | outcome                                   |
      | example                | see an error relating to Company Homepage |
      | http://ex/ample.com    | see an error relating to Company Homepage |
      | http://example         | see an error relating to Company Homepage |
      | http://example.com     | not see an error                          |
      | example.com            | not see an error                          |
      | data://example.com     | see an error relating to Company Homepage |
      | javascript:alert('no') | see an error relating to Company Homepage |
    
				
	Scenario: Supporter cannot upload images
		
		Given that I want to sign up as a supporter
		When I visit the signup page
		And I enter my details
		And I click sign up
		Then I am redirected to submit my organization details
		And I cannot see a logo upload
		And the description field is limited to 500 characters

	Scenario: Member can upload images
		
		Given that I want to sign up as a member
		When I visit the signup page
		And I enter my details
		And I click sign up
		Then I am redirected to submit my organization details
		And I can see a logo upload
		And the description field is limited to 1000 characters
	
	Scenario: Supporter tries to enter more than 500 characters
		
		Given that I want to sign up as a supporter
		When I visit the signup page
		And I enter my details
		And I click sign up
		Then I am redirected to submit my organization details
		And I enter my organization details
		And my description is 525 characters long
		Then my details should not be updated in CapsuleCRM
		When I click submit
		And I should see an error telling me that my description should not be longer than 500 characters

	Scenario: Member tries to enter more than 1000 characters
		
		Given that I want to sign up as a member
		When I visit the signup page
		And I enter my details
		And I click sign up
		Then I am redirected to submit my organization details
		And I enter my organization details
		And my description is 1035 characters long
		Then my details should be updated in CapsuleCRM
		When I click submit
		And I should see an error telling me that my description should not be longer than 1000 characters