class MembersController < ApplicationController
  respond_to :html, :json

  before_filter :get_member, :except => [:index, :right_to_cancel, :summary]
  before_filter :set_formats, :log_embed, :only => [:badge]
  before_filter :authenticate_member!, :only => [:thanks]

  before_filter(:only => [:index, :show]) {alternate_formats [:json]}

  def index
    @members = Member.where(active: true, current: true).where("organization_name IS NOT NULL").display_order

    if params[:level]
      @members = @members.where(product_name: params[:level].downcase)
    end

    @groups = @members.alpha_groups

    if @search = params[:q]
      @members = @members.search(
        m: 'or',
        name_cont: @search,
        description_cont: @search
      ).result
    elsif @alpha = params[:alpha]
      @members = @members.in_alpha_group(@alpha)
    end

    respond_with(@members)
  end

  def show
    if editable?(@member) && request.format.html?
      @preview = true
      if current_member == @member
        @title = "Edit your details"
      else
        @title = "Edit member"
      end
      render 'edit'
    else
      if @member.active == false
        if signed_in?
          raise ActiveResource::UnauthorizedAccess.new(request.fullpath) and return
        else
          session[:previous_url] = request.fullpath
          redirect_to new_member_session_path and return
        end
      end
      @title = @member.organization_name
      respond_with(@member)
    end
  end

  def badge
    render action: "badge", layout: nil
  end

  def update
    if current_admin
      if updated = @member.update_attributes(member_form_params)
        flash[:notice] = "Account updated successfully."
      end
    elsif @member == current_member
      if updated = @member.update_with_password(member_form_params)
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

  def member_form_params
    params.require(:member).permit(
      :current_password,
      :email,
      :newsletter,
      :share_with_third_parties,
      :organization_name,
      :organization_description,
      :organization_url,
      :organization_logo,
      :organization_size,
      :organization_sector,
      :organization_contact_name,
      :organization_contact_phone,
      :organization_contact_email,
      :organization_twitter,
      :organization_facebook,
      :organization_linkedin,
      :organization_tagline,
    )
  end
end
