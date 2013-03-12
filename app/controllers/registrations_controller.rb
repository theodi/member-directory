class RegistrationsController < Devise::RegistrationsController
  before_filter :check_product_name, :only => 'new'

  def edit
    @organization = @member.organization
    @preview = true
    super
  end
  
  def update
    # Prepend http to URL if not present
    if params[:organization_attributes].try(:[], :url)
      unless params[:organization_attributes][:url] =~ /^([a-z]+):\/\//
        params[:organization_attributes][:url] = "http://#{params[:organization_attributes][:url]}"
      end
    end
    # If the preview button was pressed
    if params[:commit] == 'Preview'
      # Filter passwords out
      filtered_params = params[:member].reject{|k,v| ['current_password', 'password', 'password_confirmation'].include? k}
      # Update member
      @member.attributes = filtered_params
      # Validate
      @member.valid?
      @member.organization.valid?
      # Render
      @organization = @member.organization
      render action: "edit"
    else
      # Otherwise, this is a normal save
      super
    end
  end  
  
  protected

  def check_product_name
    redirect_to 'http://www.theodi.org/join-us' unless %w{supporter member}.include?(params[:level].to_s)
  end

  def after_sign_up_path_for(resource)
    '/organizations/edit'
  end
  
end