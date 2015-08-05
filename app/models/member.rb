# encoding: utf-8

class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  SUPPORTER_LEVELS = %w[
    supporter
    member
    partner
    sponsor
    individual
  ]

  CURRENT_SUPPORTER_LEVELS = %w[
    supporter
    individual
  ]

  ORGANISATION_TYPES = {
    "Corporate" => "commercial",
    "Nonprofit / Government" => "non_commercial"
  }

  ORGANISATION_SIZES = {
    "less than 10 employees" => '<10',
    "10 - 50 employees" => '10-50',
    "51 - 250 employees" => '51-250',
    "251 - 1000 employees" => '251-1000',
    "more than 1000 employees" => '>1000'
  }

  SECTORS = [
    "Business & Legal Services",
    "Data/Technology",
    "Education",
    "Energy",
    "Environment & Weather",
    "Finance & Investment",
    "Food & Agriculture",
    "Geospatial/Mapping",
    "Governance",
    "Healthcare",
    "Housing/Real Estate",
    "Insurance",
    "Lifestyle & Consumer",
    "Media",
    "Research & Consulting",
    "Scientific Research",
    "Transportation",
    "Other"
  ]

  ORIGINS = {
    "Athens" => "odi-athens",
    "Belfast" => "odi-belfast",
    "Buenos Aires" => "odi-buenos-aires",
    "Cairo" => "odi-cairo",
    "Chicago" => "odi-chicago",
    "Devon" => "odi-devon",
    "Dubai" => "odi-dubai",
    "Gothenburg" => "odi-gothenburg",
    "Hampshire" => "odi-hampshire",
    "Leeds" => "odi-leeds",
    "Osaka" => "odi-osaka",
    "Paris" => "odi-paris",
    "Queensland" => "odi-queensland",
    "Rio" => "odi-rio",
    "Seoul" => "odi-seoul",
    "Sheffield" => "odi-sheffield",
    "St Petersburg/Moscow" => "odi-st-petersburg-moscow",
    "Toronto" => "odi-toronto",
    "Trento" => "odi-trento"
  }

  LARGE_CORPORATE = %w[251-1000 >1000]

  CHARGIFY_PRODUCT_LINKS = {}

  CHARGIFY_PRODUCT_PRICES = {}

  CHARGIFY_COUPON_DISCOUNTS = {}

  has_one :organization
  has_many :embed_stats

  accepts_nested_attributes_for :organization
  attr_accessible :organization_attributes

  before_create :set_membership_number, :set_address

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :product_name,
                  :cached_newsletter,
                  :organization_name,
                  :organization_size,
                  :organization_type,
                  :organization_sector,
                  :contact_name,
                  :telephone,
                  :street_address,
                  :address_locality,
                  :address_region,
                  :address_country,
                  :postal_code,
                  :organization_vat_id,
                  :organization_company_number,
                  :agreed_to_terms,
                  :address,
                  :origin,
                  :coupon,
                  :invoice

  attr_accessor :agreed_to_terms

  # allow admins to edit access key
  attr_accessible :access_key, as: :admin

  # validations
  validates :product_name, presence: true, inclusion: SUPPORTER_LEVELS, on: :create
  validates :contact_name, presence: true, on: :create
  validates :street_address, presence: true, on: :create
  validates :address_region, presence: true, on: :create
  validates :address_country, presence: true, on: :create
  validates :postal_code, presence: true, on: :create
  validates_acceptance_of :agreed_to_terms, on: :create

  validates_with OrganizationValidator, on: :create, unless: :individual?

  scope :current, where(:current => true)
  scope :valid, where('product_name is not null')

  def remote?
    @remote || false
  end

  def remote!
    @remote = true
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(membership_number) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_hash).first
    end
  end

  def current!
    update_attribute(:cached_active, true) if organization?
    update_attribute(:current, true)
  end

  def deliver_welcome_email!
    send_devise_notification(:confirmation_instructions)
  end

  def process_invoiced_member!
    current!
    add_to_capsule
    deliver_welcome_email!
  end

  def check_organization_names
    if new_record? # Only validate on create
      unless Organization.where(:name => organization_name).empty?
        errors.add(:organization_name, "is already taken")
      end
    end
  end

  def to_param
    membership_number
  end

  def supporter?
    product_name == "supporter"
  end

  def individual?
    self.class.is_individual_level?(product_name)
  end

  def organization?
    %w[partner sponsor supporter].include?(product_name)
  end

  def large_corporate_organization?
    LARGE_CORPORATE.include?(organization_size) && organization_type == 'commercial'
  end

  def monthly_payment_option?
    organization? && !large_corporate_organization?
  end

  def founding_partner?
    if founding_parter_id = ENV['FOUNDING_PARTNER_ID']
      membership_number == founding_parter_id
    end
  end

  def abandoned_signup?
    errors.messages[:email] && errors.messages[:email].include?("has already been taken") && !current?
  end

  def invoiced_member?
    self.invoice === true && self.product_name == "supporter"
  end

  def badge_class
    if %w[partner sponsor].include?(product_name)
      "partner"
    else
      "supporter"
    end
  end

  def organization_name
    organization.try(:name) || @organization_name
  end

  def organization_name=(value)
    @organization_name = value.try(:strip)
  end

  def contact_name
    @contact_name || name.presence
  end

  def telephone
    @telephone || phone.presence
  end

  def contact_name=(value)
    @contact_name = value
    self.name = value
  end

  def telephone=(value)
    @telephone = value
    self.phone = value
  end

  def membership_description
    if founding_partner?
      'Founding partner'
    elsif organization?
      product_name.titleize
    else
      "Supporter"
    end
  end

  def self.initialize_chargify_links!
    product_family_ids = Set.new
    Chargify::Product.all.each do |product|
      # yep, this is how good the chargify API naming is
      # also no way to find the currency of a Site either
      register_chargify_product_price(product.handle, product.price_in_cents)
      page = product.public_signup_pages.first
      if page
        register_chargify_product_link(product.handle, page.url)
      end
      product_family_ids.add(product.product_family.id)
    end
    product_family_ids.each do |product_family_id|
      Chargify::Coupon.all(params: {product_family_id: product_family_id}).each do |coupon|
        register_chargify_coupon_code(coupon.code, coupon.percentage) unless coupon.archived_at.present?
      end
    end
  end

  def self.register_chargify_product_link(plan, url)
    CHARGIFY_PRODUCT_LINKS[plan] = url
  end

  def self.register_chargify_product_price(plan, cents_that_are_pence)
    CHARGIFY_PRODUCT_PRICES[plan] = cents_that_are_pence.to_i / 100
  end

  def self.register_chargify_coupon_code(code, percentage)
    CHARGIFY_COUPON_DISCOUNTS[code] = percentage == 100 ? :free : :discount
  end

  def chargify_product_handle
    get_plan
  end

  def chargify_product_link
    if link = CHARGIFY_PRODUCT_LINKS[chargify_product_handle]
      url = URI(link)
      first_name, last_name = contact_name.split(/\s+/, 2)
      params = {
        first_name: first_name,
        last_name: last_name,
        reference: membership_number,
        email: email,
        billing_address: street_address,
        billing_address_2: address_locality,
        billing_city: address_region,
        billing_country: address_country,
        billing_state: "London", #this doesn't actually prefil but it makes chargify calculate tax based on country
        billing_zip: postal_code
      }
      params[:organization] = organization_name if organization?
      params[:coupon_code] = coupon if coupon.present?
      url.query = params.to_query
      return url.to_s
    else
      raise ArgumentError, "no link for #{chargify_product_handle}"
    end
  end

  def update_chargify_values!(params)
    self.chargify_customer_id ||= params[:customer_id]
    self.chargify_subscription_id ||= params[:subscription_id]
    self.chargify_payment_id ||= params[:payment_id]
    save!
  end

  def verify_chargify_subscription!(subscription, customer)
    update_attributes!({
      chargify_customer_id: customer['id'],
      chargify_subscription_id: subscription['id'],
      chargify_payment_id: subscription['signup_payment_id'],
      chargify_data_verified: true
    }, without_protection: true)
    add_to_capsule
  end

  def self.founding_partner_id
    ENV['FOUNDING_PARTNER_ID']
  end

  def register_embed(referrer)
    begin
      embed_stats.create(referrer: referrer)
    rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid
      nil
    end
  end

  def get_plan_description
    {
      'individual-supporter'            => 'Individual Supporter',
      'corporate-supporter_annual' => 'Corporate Supporter',
      'supporter_annual'                => 'Supporter',
      'supporter_monthly'                => 'Supporter'
    }[get_plan]
  end

  def get_plan_price
    amount = CHARGIFY_PRODUCT_PRICES[get_plan]
    if address_country == 'GB'
      if individual?
        inc_vat, vat = amount * 1.2, amount * 0.2
        "£%.2f including £%.2f VAT" % [inc_vat, vat]
      else
        "£%.2f + VAT" % amount
      end
    else
      "£%.2f" % amount
    end
  end

  def get_monthly_plan_price
    amount = CHARGIFY_PRODUCT_PRICES[get_plan]
    pcm = (amount / 12)
    if address_country == 'GB'
      "£%.2f + VAT" % pcm
    else
      "£%.2f" % pcm
    end
  end

	private

  def generate_membership_number
    chars = ('A'..'Z').to_a
    chars.sample + chars.sample + "%04d" % SecureRandom.random_number(9999) + chars.sample + chars.sample
  end

  def set_membership_number
    unless membership_number
      begin
        self.membership_number = generate_membership_number
      end while self.class.exists?(membership_number: membership_number)
    end
  end

  def set_address
    self.address = [
      street_address,
      address_locality,
      address_region,
      country_name,
      postal_code
    ].compact.join("\n")
  end

  after_create :setup_organization
  after_create :save_membership_id_in_capsule, if: :remote?

  def add_to_capsule

    # construct hashes for signup processor
    # some of the naming of purchase order and membership id needs updating for consistency
    organization = {
      'name' => organization_name,
      'vat_id' => organization_vat_id,
      'company_number' => organization_company_number,
      'size' => organization_size,
      'type' => organization_type,
      'sector' => organization_sector
    }

    contact_person  = {
      'name' => contact_name,
      'email' => email,
      'telephone' => telephone
    }

    billing = {
      'name' => contact_name,
      'email' => email,
      'telephone' => telephone,
      'address' => {
        'street_address' => street_address,
        'address_locality' => address_locality,
        'address_region' => address_region,
        'address_country' => country_name,
        'postal_code' => postal_code
      }
    }

    purchase = {
      'payment_method' => invoiced_member? ? 'invoice' : 'credit_card',
      'payment_ref' => chargify_payment_id,
      'offer_category' => product_name,
      'membership_id' => membership_number
    }

    Resque.enqueue(SignupProcessor, organization, contact_person, billing, purchase)
  end

  after_update :save_updates_to_capsule, unless: :remote?

  def save_updates_to_capsule
    unless (changed & %w[email cached_newsletter organization_size organization_sector]).empty?
      Resque.enqueue(SaveMembershipDetailsToCapsule, membership_number, {
        'email'      => email,
        'newsletter' => cached_newsletter,
        'size'       => organization_size,
        'sector'     => organization_sector
      })
    end
  end

  def save_membership_id_in_capsule
    if individual?
      Resque.enqueue(SaveMembershipIdInCapsule, nil, email, membership_number)
    else
      Resque.enqueue(SaveMembershipIdInCapsule, organization_name, nil, membership_number)
    end
  end

  def setup_organization
    self.create_organization(:name => organization_name) unless individual?
  end

  def get_plan
    if individual?
      'individual-supporter'
    else
      if large_corporate_organization?
        'corporate-supporter_annual'
      elsif payment_frequency == 'monthly'
        'supporter_monthly'
      else
        'supporter_annual'
      end
    end
  end

  def country_name
    country = ISO3166::Country[address_country]
    return "" if country.nil?
    country.translations[I18n.locale.to_s] || country.name
  end

  def self.is_current_supporter_level?(level)
    CURRENT_SUPPORTER_LEVELS.include?(level)
  end

  def self.is_individual_level?(level)
    'individual' == level
  end

  def self.sectors
    SECTORS
  end

  def self.summary
    {
      total: Member.valid.current.count,
      breakdown: Member.valid.current.group(:product_name).count,
      all: {
        total: Member.valid.count,
        breakdown: Member.valid.group(:product_name).count
      }
    }
  end
end

