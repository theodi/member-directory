module DeviseHelper

  def devise_error_messages!
    error_messages(resource)
  end

  def product_name
    params[:level] || @member.product_name
  end

end
