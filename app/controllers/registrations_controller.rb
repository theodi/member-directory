class RegistrationsController < Devise::RegistrationsController
  before_filter :check_product_name, :only => 'new'

  def edit
    @preview = true
    super
  end
  
  def update
    # Prepend http to URL if not present
    if params[:member].try(:[], :organization_attributes).try(:[], :url)
      unless params[:member][:organization_attributes][:url] =~ /^([a-z]+):\/\//
        params[:member][:organization_attributes][:url] = "http://#{params[:member][:organization_attributes][:url]}"
      end
    end
    # Call base update
    super
  end  
  
  protected

  def check_product_name
    redirect_to 'http://www.theodi.org/join-us' unless %w{supporter member partner sponsor}.include?(params[:level].to_s)
  end

  def after_sign_up_path_for(resource)
    '/members/edit'
  end
  
end