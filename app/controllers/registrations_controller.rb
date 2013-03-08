class RegistrationsController < Devise::RegistrationsController
  before_filter :check_product_name, :only => 'new'

  protected

  def check_product_name
    redirect_to 'http://www.theodi.org/join-us' unless %w{supporter member}.include?(params[:level].to_s)
  end

  def after_sign_up_path_for(resource)
    '/organizations/edit'
  end
  
end