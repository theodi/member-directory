class MembersController < ApplicationController

  def index
    @organizations = Organization.includes(:member).where(:'members.cached_active' => true).order(:name)
  end

  def show
    # Get member
    @member = Member.where(:membership_number => params[:id]).first
    raise ActiveRecord::RecordNotFound and return if @member.nil? || @member.cached_active != true
    # Get organization
    @organization = @member.organization
    raise ActiveRecord::RecordNotFound and return if @organization.nil?
  end
  
end
