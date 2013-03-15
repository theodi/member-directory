class MembersController < ApplicationController
  respond_to :html, :json

  def index
    @organizations = Organization.includes(:member).where(:'members.cached_active' => true).order(:name)
    respond_with(@organizations)
  end

  def show
    # Get member
    @member = Member.where(:membership_number => params[:id]).first
    raise ActiveRecord::RecordNotFound and return if @member.nil? || @member.cached_active != true
    # Get organization
    @organization = @member.organization
    raise ActiveRecord::RecordNotFound and return if @organization.nil?
    respond_with(@organization)
  end
  
end
