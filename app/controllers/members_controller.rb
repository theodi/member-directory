class MembersController < ApplicationController
  respond_to :html, :json

  before_filter :get_member, :except => [:index]

  before_filter(:only => [:index, :show]) {set_alternate_formats [:json]}

  def index
    if params[:level]
      @organizations = Organization.includes(:member).where(:'members.cached_active' => true, :'members.product_name' => params[:level].downcase)
    else
      @organizations = []
      ['partner','sponsor','member','supporter'].each do |level|
        @organizations << Organization.includes(:member).where(:'members.cached_active' => true, :'members.product_name' => level).order(:name)
      end
      @organizations.flatten!
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
      raise ActiveRecord::RecordNotFound and return if @organization.nil? 
      if @member.cached_active == false
        if signed_in?
          raise ActiveResource::UnauthorizedAccess.new(request.fullpath) and return
        else
          session[:previous_url] = request.fullpath
          redirect_to new_member_session_path and return
        end
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
