class MembersController < ApplicationController
  respond_to :html, :json

  before_filter :get_member, :except => [:index, :right_to_cancel, :chargify_verify]
  before_filter :set_formats, :log_embed, :only => [:badge]

  before_filter(:only => [:index, :show]) {alternate_formats [:json]}

  before_filter :verify_chargify_webhook, :only => :chargify_verify

  def index
    @organizations = Organization.active.display_order

    if params[:level]
      @organizations = @organizations.for_level(params[:level].downcase)
    end

    @groups = @organizations.alpha_groups

    if @search = params[:q]
      @organizations = @organizations.search(
        m: 'or',
        name_cont: @search,
        description_cont: @search
      ).result
    elsif @alpha = params[:alpha]
      @organizations = @organizations.in_alpha_group(@alpha)
    end

    respond_with(@organizations)
  end

  def show
    # Get organization
    @organization = @member.organization
    if editable?(@member) && request.format.html?
      @preview = true
      if current_member == @member
        @title = "Edit your details"
      else
        @title = "Edit member"
      end
      render 'edit'
    else
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

  def right_to_cancel
    @title = "Membership agreement: Right to cancel"
  end

  def thanks
    @title = "Thanks for supporting The ODI"
  end

  def chargify_verify
    case(params['event'])
    when 'test'
    when 'signup_success'
      subscription = params['payload']['subscription']
      customer = subscription['customer']
      member = Member.find_by_membership_number!(customer['reference'])
      member.verify_chargify_subscription!(subscription, customer)
      member.update_address_from_chargify(customer)
    end
    head :ok
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

  def verify_chargify_webhook
    key = ENV['CHARGIFY_SITE_KEY']
    body = request.raw_post
    provided_digest = request.headers['X-Chargify-Webhook-Signature-Hmac-Sha-256']
    digest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), key, body)
    head :unauthorized unless Devise.secure_compare(provided_digest, digest)
  end

end
