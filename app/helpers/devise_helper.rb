module DeviseHelper

  def devise_error_messages!
    error_messages(resource)
  end

  def product_name
    params[:level] || @member.product_name
  end

  def annual_product_price
    case product_name
    when 'supporter'
      "&pound;720".html_safe
    when 'sponsor'
      "&pound;25,000".html_safe      
    when 'partner'
      "&pound;50,000".html_safe
    end
  end

end
