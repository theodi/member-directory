class MembersController < ApplicationController
  respond_to :html, :json

  before_filter :get_member, :except => [:index, :right_to_cancel, :summary]
  before_filter :set_formats, :log_embed, :only => [:badge]
  before_filter :authenticate_member!, :only => [:thanks]

  before_filter(:only => [:index, :show]) {alternate_formats [:json]}

  before_filter :ensure_current, :only => :show

  def index
    @listings = Listing.active.display_order

    if params[:level]
      @listings = @listings.for_level(params[:level].downcase)
    end

    @groups = @listings.alpha_groups

    if @search = params[:q]
      @listings = @listings.search(
        m: 'or',
        name_cont: @search,
        description_cont: @search
      ).result
    elsif @alpha = params[:alpha]
      @listings = @listings.in_alpha_group(@alpha)
    end

    respond_with(@listings)
  end

  def show
    # Get listing
    @listing = @member.listing
    if editable?(@member) && request.format.html?
      @preview = true
      if current_member == @member
        @title = "Edit your details"
      else
        @title = "Edit member"
      end
      render 'edit'
    else
      raise ActiveRecord::RecordNotFound and return if @listing.nil?
      if @member.active == false
        if signed_in?
          raise ActiveResource::UnauthorizedAccess.new(request.fullpath) and return
        else
          session[:previous_url] = request.fullpath
          redirect_to new_member_session_path and return
        end
      end
      @title = @listing.name
      respond_with(@listing)
    end
  end

  def badge
    render action: "badge", layout: nil
  end

  def update
    if current_admin
      if updated = @member.update_attributes(params[:member])
        flash[:notice] = "Account updated successfully."
      end
    elsif @member == current_member
      if updated = @member.update_with_password(params[:member])
        flash[:notice] = "You updated your account successfully."
      end
    end

    respond_with(@member)
  end

  def right_to_cancel
    @title = "Membership agreement: Right to cancel"
  end

  def summary
    render xml: Member.summary.to_xml(:root => :summary)
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

  def ensure_current
    redirect_to payment_member_path(@member) unless @member.current?
  end

end
