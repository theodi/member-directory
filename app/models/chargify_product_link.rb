class ChargifyProductLink
  def self.for(member)
    new(member).url
  end

  attr_reader :member

  def initialize(member)
    @member = member
  end

  def url
    if link = product_links[product_handle]
      url = URI(link)
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
      url.query = params.to_query
      return url.to_s
    else
      raise ArgumentError, "no link for #{product_handle}"
    end
  end

  def product_links
    Member::CHARGIFY_PRODUCT_LINKS
  end

  def product_handle
    member.plan
  end
end

