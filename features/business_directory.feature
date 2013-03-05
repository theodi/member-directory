Feature: Adding details to the business directory

	As a member, I want my details to be listed on the business directory and stored in capsule
	
	Scenario: Supporter cannot upload images
		
		Given that I have signed up as a supporter
		When I click 'Sign up'
		Then I am redirected to submit my business details
		And I cannot see a logo upload
		And the description field is limited to 500 characters

	Scenario: Member can upload images
		
		Given that I have signed up as a member
		When I click 'Sign up'
		Then I am redirected to submit my business details
		And I can see a logo upload
		And the description field is limited to 1000 characters
	
	Scenario Outline: Business directory upload
	
		Given that I have signed up as a member
		When I click 'Sign up'
		Then I am redirected to submit my business details
		
		Scenario: Sucessful business directory upload
			
			Given that I enter my request details
			Then my submission should be queued for futher processing
			When I click submit
			
		Scenario: User tries to submit their details, but misses a mandatory field
		
			Given that I enter my request details
			But I leave <field> blank
			Then my submission should not be queued for futher processing
			When I click submit
			And I should see an error relating to <text>
			
				| field       | text         |
				| name        | Organisation |
				| description | Description  |
				| url         | Website      |
	
	Scenario: Supporter tries to enter more than 500 characters
		
		Given that I have signed up as a supporter
		When I click 'Sign up'
		Then I am redirected to submit my business details
		And I enter my request details
		And my description is 525 characters long
		Then my submission should not be queued for futher processing
		When I click submit
		And I should see an error telling me that my description is too long

	Scenario: Member tries to enter more than 1000 characters
		
		Given that I have signed up as a supporter
		When I click 'Sign up'
		Then I am redirected to submit my business details
		And I enter my request details
		And my description is 1035 characters long
		Then my submission should not be queued for futher processing
		When I click submit
		And I should see an error telling me that my description is too long