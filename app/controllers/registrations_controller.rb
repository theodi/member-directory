class RegistrationsController < Devise::RegistrationsController
  before_filter :check_product_name, :only => 'new'
  before_filter :set_title, :only => %w[new create]
  helper_method :individual?

  # copied from https://github.com/plataformatec/devise/blob/v2.2.8/app/controllers/devise/registrations_controller.rb
  # because can't use super as that would cause a double render
  def new
    resource = build_resource({product_name: params[:level]})
    respond_with resource
  end

  def create
    build_resource

    if resource.save
      sign_up(resource_name, resource)
      if resource.paid_with_card?
        redirect_to resource.chargify_product_link(params[:coupon])
      else
        current_member.setup_chargify_subscription!
        redirect_to thanks_member_path(current_member)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def chargify_return
    current_member.update_chargify_values!(params)
    redirect_to thanks_member_path(current_member)
  end

  protected

  def check_product_name
    redirect_to 'http://www.theodi.org/join-us' unless Member.is_current_supporter_level?(params[:level])
  end

  def set_title
    @title = "Become an ODI member"
  end

  def individual?
    resource.individual?
  end

end
