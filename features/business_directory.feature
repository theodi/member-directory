Feature: Adding details to the organization directory

	As a member, I want my details to be listed on the organization directory and stored in capsule

	Scenario: Sucessful organization directory upload
			
		Given that I have signed up
		Then I am redirected to submit my organization details
		And I enter my organization details
		When I click submit
    Then I should see a preview page
    And I click submit
    Then I should see a notice saying my submission has been added
    
  Scenario: User adds organization details, but wants to edit them
			
		Given that I have signed up 
		And I enter my organization details
		When I click submit
    Then I should see a preview page
    And I click edit
    Then I should be able to edit my details
    And I edit my details
    And I click submit
    Then I should see my changed details on the preview page  
			
	Scenario Outline: User tries to submit their details, but misses a mandatory field
		
		Given that I have signed up
		Then I am redirected to submit my organization details
		And I enter my organization details
		But I leave my organization <field> blank
		And I click submit
		Then I should see an error relating to <text>
			
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
		
		Given that I have signed up as a supporter
		Then I am redirected to submit my organization details
		And I cannot see a logo upload
		And the description field is limited to 500 characters

	Scenario: Member can upload images
		
		Given that I have signed up as a member
		Then I am redirected to submit my organization details
		And I can see a logo upload
		And the description field is limited to 1000 characters
	
	Scenario: Supporter tries to enter more than 500 characters
		
		Given that I have signed up as a supporter
		Then I am redirected to submit my organization details
		And I enter my organization details
		And my description is 525 characters long
		And I click submit
		Then I should see an error telling me that my description should not be longer than 500 characters

	Scenario: Member tries to enter more than 1000 characters
		
		Given that I have signed up as a member
		Then I am redirected to submit my organization details
		And I enter my organization details
		And my description is 1035 characters long
    And I click submit
		Then I should see an error telling me that my description should not be longer than 1000 characters
