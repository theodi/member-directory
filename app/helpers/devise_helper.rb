module DeviseHelper

  def devise_error_messages!
    error_messages(resource)
  end

  def product_name
    params[:level] || @member.product_name
  end

  def annual_product_price(modifier = nil)
    case product_name
    when 'supporter'
      if modifier == :corporate
        "&pound;1,440".html_safe
      else
        "&pound;720".html_safe
      end
    when 'sponsor'
      "&pound;25,000".html_safe
    when 'partner'
      "&pound;50,000".html_safe
    end
  end

  def payment_frequency_options
    case product_name
    when 'individual'
      [["Yearly", :annual]]
    else
      [["Yearly", :annual], ["Monthly", :monthly]]
    end
  end

end
