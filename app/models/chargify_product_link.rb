require "yaml"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/object/to_query"

class ChargifyProductLink
  def self.for(member)
    new(member).url
  end

  attr_reader :member
  attr_writer :env, :config_file

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
    config["product_url"]
  end

  def product_handle
    member.plan
  end

  def public_signup_page_id
    product_links.fetch(public_signup_page_key) do
      raise ArgumentError, "No page id for `#{product_handle}` in config/chargify.yml"
    end
  end

  def public_signup_page_key
    case
    when member.individual?
      :individual_pay_what_you_like
    when member.individual? && member.no_payment?
      :individual_pay_what_you_like_free
    when member.student? && member.no_payment?
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
    config["page_ids"]
  end

  def config
    YAML.load_file(config_file)[env]
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

    params[:components] = [
      {
        component_id: ENV['CHARGIFY_COMPONENT_ID'],
        allocated_quantity: member.price_without_vat(member.subscription_amount.to_i)
      }
    ] if member.individual?

    params
  end

  def customer_attributes
    first_name, last_name = member.contact_name.split(/\s+/, 2)
    {
      first_name: first_name,
      last_name: last_name,
      reference: member.membership_number,
      email: member.email,
      organization: member.organization || member.university_name_other || member.university_name,
    }
  end

  def payment_profile_attributes
    {
      billing_address: member.street_address,
      billing_address_2: member.address_locality,
      billing_city: member.address_region,
      billing_country: member.address_country,
      billing_state: "London", #this doesn't actually prefil but it makes chargify calculate tax based on country
      billing_zip: member.postal_code
    }
  end

  def config_file
    @config_file ||= "#{Rails.root}/config/chargify.yml"
  end

  def env
    @env ||= Rails.env
  end
end
