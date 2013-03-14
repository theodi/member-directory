class MembersController < ApplicationController
  respond_to :html, :json

  before_filter :get_member, :except => [:index]

  def index
    @organizations = Organization.includes(:member).where(:'members.cached_active' => true).order(:name)
    respond_with(@organizations)
  end

  def show
    # Get organization
    @organization = @member.organization
    raise ActiveRecord::RecordNotFound and return if @organization.nil? || @member.cached_active != true
    respond_with(@organization)
  end
  
  private
  
  def get_member
    # Get member
    @member = Member.where(:membership_number => params[:id]).first
    raise ActiveRecord::RecordNotFound and return if @member.nil?
  end
  
end
