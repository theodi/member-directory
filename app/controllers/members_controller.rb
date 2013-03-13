class MembersController < ApplicationController

  def index
    @organizations = Organization.order(:name)
  end

  def show
    # Get member
    @member = Member.where(:membership_number => params[:id]).first
    raise ActiveRecord::RecordNotFound and return if @member.nil?
    # Get organization
    @organization = @member.organization
    raise ActiveRecord::RecordNotFound and return if @organization.nil?
  end
  
end
