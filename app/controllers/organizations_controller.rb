class OrganizationsController < ApplicationController

  # GET /organizations/edit
  def edit
    if member_signed_in?
      @member = current_member
      @organization = @member.organization
      @member.product_name == "supporter" ? @limit = 500 : @limit = 1000 
    else
      redirect_to root_path
    end
  end
  
  # POST /organizations
  def update
    if member_signed_in?
      @member = current_member
      @organization = current_member.organization
      @member.product_name == "supporter" ? @limit = 500 : @limit = 1000  
      if @organization.update_attributes(params[:organization])
        redirect_to root_path, :notice => 'Your submission has been added. A more elegant message will go here.'
      else
        render action: "edit"
      end    
    else
      redirect_to root_path
    end
  end
  
end