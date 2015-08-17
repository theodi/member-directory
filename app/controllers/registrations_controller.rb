class RegistrationsController < Devise::RegistrationsController
  before_filter :check_product_name, :only => 'new'
  before_filter :set_title, :only => %w[new create]
  helper_method :individual?, :student?

  # copied from https://github.com/plataformatec/devise/blob/v2.2.8/app/controllers/devise/registrations_controller.rb
  # because can't use super as that would cause a double render
  def new
    resource = build_resource({product_name: params[:level]})
    save_origin
    respond_with resource
  end

  def create
    resource = build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      if resource.abandoned_signup?
        new_resource = resource.class.where(email: resource.email).first
        password = resource.password
        sign_out(resource)
        resource.delete

        if new_resource.valid_password?(password)
          sign_in(new_resource)
          redirect_to(payment_member_path new_resource, coupon: params[:coupon].presence) and return
        else
          flash.alert = "You have already started the signup process, to continue to payment, please login.<br /> Forgotten your password? Just click the \"Forgotten password?\" link and we'll send you a link to reset it.".html_safe
          redirect_to(new_member_session_path(login: new_resource.membership_number)) and return
        end
      end
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

  def is_navigational_format?
    false
  end

  def set_flash_message(key, kind, options = {})
    if kind == :signed_up
      kind = :"signed_up_#{resource.product_name}"
    end
    super(key, kind, options)
  end

  def after_sign_up_path_for(resource)
    if resource.invoiced?
      thanks_member_path(resource)
    else
      payment_member_path(resource, coupon: params[:coupon].presence)
    end
  end

  def check_product_name
    redirect_to 'http://www.theodi.org/join-us' unless Member.is_current_supporter_level?(params[:level])
  end

  def set_title
    @title = "Become an ODI member"
  end

  def individual?
    resource.individual?
  end

  def student?
    resource.student?
  end

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end

  def save_origin
    return if !params[:origin].present?

    cookies[:origin] = params[:origin]
  end

  def origin_value
    if params[:member] && params[:member][:origin].present?
      return params[:member][:origin]
    end

    cookies[:origin]
  end

  helper_method :origin_value
end

