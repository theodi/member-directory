class MembersController < ApplicationController
  respond_to :html, :json

  before_filter :get_member, :except => [:index]

  before_filter :set_alternate_formats, :only => [:index, :show]

  def index
    @organizations = Organization.includes(:member).where(:'members.cached_active' => true).order(:name)
    if params[:level]
      @organizations = @organizations.where(:'members.product_name' => params[:level].downcase)
    end
    respond_with(@organizations)
  end

  def show
    # Get organization
    if current_member == @member && request.format.html?
      @preview = true
      render 'edit'      
    else
      @organization = @member.organization
      if @organization.nil? || @member.cached_active == false
        raise ActiveRecord::RecordNotFound and return 
      end
      respond_with(@organization)
    end
  end
  
  def update
    # Prepend http to URL if not present
    if params[:member] && params[:member][:organization_attributes] && params[:member][:organization_attributes][:url]
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
