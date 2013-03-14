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
    if @organization.nil? || (current_member != @member && @member.cached_active == false)
      raise ActiveRecord::RecordNotFound and return 
    end
    respond_with(@organization)
  end
  
  def edit
    @preview = true
    respond_with(@member)
  end
  
  def update
    # Prepend http to URL if not present
    if params[:member].try(:[], :organization_attributes).try(:[], :url)
      unless params[:member][:organization_attributes][:url] =~ /^([a-z]+):\/\//
        params[:member][:organization_attributes][:url] = "http://#{params[:member][:organization_attributes][:url]}"
      end
    end
    # Update
    if @member.update_with_password params[:member]
      flash[:notice] = "You updated your account successfully."
    end
    respond_with(@member)
  end

  private
  
  def get_member
    # Get member
    @member = Member.where(:membership_number => params[:id]).first
    raise ActiveRecord::RecordNotFound and return if @member.nil?
  end
  
end
