class IndividualPresenter
  include ActionView::Helpers::TagHelper
  attr_reader :member

  def initialize(member)
    @member = member
  end

  def name
    content_tag(:span, member.name, class: 'legal-name')
  end

  def address
    addr = member.address.split("\n").join(", ")
    content_tag(:span, addr, class: 'legal-address')
  end

  def start_date
    member.created_at.to_date.to_formatted_s(:long_ordinal)
  end
end
