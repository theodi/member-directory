class OrganizationsController < ApplicationController

  # GET /organizations/edit
  def edit
    if member_signed_in?
      @organization = Organization.find_by_membership_number(current_member.membership_number)
      puts @organization.to_yaml
    else
      redirect_to('/') 
    end
  end
  
  # POST /organizations
  def update
    if member_signed_in?
      @organization = Organization.find_by_membership_number(current_member.membership_number)    
      if @organization.update_attributes(params[:organization])
        @organization.save
        redirect_to '/', :notice => 'Your submission has been added. A more elegant message will go here.'
      else
        render action: "edit"
      end    
    else
      redirect_to('/')
    end
  end
  
end