class PlaceholderPresenter
  include ActionView::Helpers::TagHelper

  def name
    content_tag(:span, '(name)', class: 'legal-name')
  end

  def address
    content_tag(:span, '(address)', class: 'legal-address')
  end

  def company_number
    content_tag(:span, '(company number)', class: 'company-number')
  end

  def start_date
    Date.today.to_formatted_s(:long_ordinal)
  end

end
