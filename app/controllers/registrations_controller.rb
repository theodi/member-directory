class RegistrationsController < Devise::RegistrationsController
  before_filter :check_product_name, :only => 'new'

  def check_product_name
    redirect_to 'http://www.theodi.org/join-us' unless %w{supporter member}.include?(params[:level].to_s)
  end

end
