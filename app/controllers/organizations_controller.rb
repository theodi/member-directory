class OrganizationsController < ApplicationController

  # GET /organizations/edit
  def edit
    if member_signed_in?
      @organization = current_member.organization
      puts @organization.to_yaml
    else
      redirect_to root_path
    end
  end
  
  # POST /organizations
  def update
    if member_signed_in?
      @organization = current_member.organization    
      if @organization.update_attributes(params[:organization])
        redirect_to '/', :notice => 'Your submission has been added. A more elegant message will go here.'
      else
        render action: "edit"
      end    
    else
      redirect_to root_path
    end
  end
  
end