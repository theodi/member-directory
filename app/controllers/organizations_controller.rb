class OrganizationsController < ApplicationController

  # GET /organizations/edit
  def edit
    if member_signed_in?
      @organization = current_member.organization
    else
      redirect_to root_path
    end
  end
  
  # POST /organizations
  def update
    if member_signed_in?
      @organization = current_member.organization
      if @organization.update_attributes(params[:organization])
        render action: "preview"
      else
        render action: "edit"
      end    
    else
      redirect_to root_path
    end
  end
  
end