require "active_support/core_ext/object/blank"
require "active_support/core_ext/object/to_query"

class ChargifyProductLink
  def self.for(member)
    new(member).url
  end

  attr_reader :member

  def initialize(member)
    @member = member
  end

  def url
    url = URI(product_link)
    url.query = params.to_query
    url.to_s
  end

  def product_link
    product_url % [public_signup_page_id, product_handle]
  end

  def product_url
    ENV.fetch("CHARGIFY_PRODUCT_URL") do
      raise ArgumentError, "CHARGIFY_PRODUCT_URL is missing"
    end
  end

  def product_handle
    member.plan
  end

  def public_signup_page_id
    product_links.fetch(public_signup_page_key) do
      raise ArgumentError, "No page id for `#{product_handle}` in CHARGIFY_PAGE_IDS"
    end
  end

  def public_signup_page_key
    case
    when member.individual?
      :individual_supporter
    when member.student_free?
      :individual_supporter_student_free
    when member.student?
      :individual_supporter_student
    when member.large_corporate_organization?
      :corporate_supporter_annual
    when member.supporter? && member.payment_frequency == 'monthly'
      :supporter_monthly
    else
      :supporter_annual
    end
  end

  def product_links
    product_page_ids.split("|").each_with_object({}) do |page, accum|
      product_name, id = page.split(",")
      accum[product_name.to_sym] = id
    end
  end

  def product_page_ids
    ENV.fetch("CHARGIFY_PAGE_IDS") do
      raise ArgumentError, "CHARGIFY_PAGE_IDS is missing"
    end
  end

  def params
    first_name, last_name = member.contact_name.split(/\s+/, 2)
    params = {
      first_name: first_name,
      last_name: last_name,
      reference: member.membership_number,
      email: member.email,
      billing_address: member.street_address,
      billing_address_2: member.address_locality,
      billing_city: member.address_region,
      billing_country: member.address_country,
      billing_state: "London", #this doesn't actually prefil but it makes chargify calculate tax based on country
      billing_zip: member.postal_code
    }
    params[:organization] = member.organization_name if member.organization?
    params[:coupon_code] = member.coupon if member.coupon.present?
    params
  end
end

