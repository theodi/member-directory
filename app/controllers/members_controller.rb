class MembersController < ApplicationController
  respond_to :html, :json

  before_filter :get_member, :except => [:index]
  before_filter :set_formats, :log_embed, :only => [:badge]

  before_filter(:only => [:index, :show]) {alternate_formats [:json]}

  def index
    if params[:level]
      @organizations = Organization.includes(:member).where(:'members.cached_active' => true, :'members.product_name' => params[:level].downcase)
    else
      @organizations = []
      # Make sure we get the founding partner first
      founding_partner = ENV['FOUNDING_PARTNER_ID'] || 0
      @organizations << Organization.includes(:member).where(:'members.membership_number' => founding_partner).first
      ['partner','sponsor','member','supporter'].each do |level|
        @organizations << Organization.includes(:member).where(:'members.cached_active' => true, :'members.product_name' => level)
                          .where('members.membership_number != ?', founding_partner)
                          .order(:name)
      end
      @organizations.flatten!.compact!
    end

    respond_with(@organizations)
  end

  def show
    # Get organization
    if editable?(@member.organization) && request.format.html?
      @preview = true
      if current_member == @member
        @title = "Edit your details"
      else
        @title = "Edit member"
      end
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
      @title = @organization.name
      respond_with(@organization)
    end
  end

  def badge
    render action: "badge", layout: nil
  end

  def update
    # Prepend http to URL if not present
    if params[:member] && params[:member][:organization_attributes] && params[:member][:organization_attributes][:url]
      unless params[:member][:organization_attributes][:url] =~ /^([a-z]+):\/\//
        params[:member][:organization_attributes][:url] = "http://#{params[:member][:organization_attributes][:url]}"
      end
    end
    # Update
    if current_admin
      if @member.update_attributes params[:member]
        flash[:notice] = "Account updated successfully."
      end
    elsif @member == current_member
      if @member.update_with_password params[:member]
        flash[:notice] = "You updated your account successfully."
      end
    end
    respond_with(@member)
  end

  private

  def get_member
    # Get member
    @member = Member.where(:membership_number => params[:id]).first
    raise ActiveRecord::RecordNotFound and return if @member.nil?
  end

  def log_embed
    unless request.referer =~ /https?:\/\/#{request.host_with_port}./
      @member.register_embed(request.referer)
    end
  end

end
