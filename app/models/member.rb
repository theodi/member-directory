class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  SUPPORTER_LEVELS = %w[supporter member partner sponsor individual]
  CURRENT_SUPPORTER_LEVELS = %w[supporter individual]

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
  LARGE_CORPORATE = %w[251-1000 >1000]
  CHARGIFY_PRODUCT_LINKS = {}

  has_one :organization
  has_many :embed_stats

  accepts_nested_attributes_for :organization
  attr_accessible :organization_attributes

  before_create :set_membership_number, :set_address
  before_validation :set_defaults

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
                  :card_number,
                  :card_validation_code,
                  :card_expiry_month,
                  :card_expiry_year,
                  :purchase_order_number,
                  :agreed_to_terms,
                  :payment_method,
                  :address

  attr_accessor :organization_name,
                :organization_type,
                :street_address,
                :address_locality,
                :address_region,
                :address_country,
                :postal_code,
                :organization_vat_id,
                :organization_company_number,
                :card_number,
                :card_validation_code,
                :card_expiry_month,
                :card_expiry_year,
                :purchase_order_number,
                :agreed_to_terms,
                :payment_method

  # allow admins to edit access key
  attr_accessible :access_key, as: :admin

	# validations
  validates :product_name, presence: true, inclusion: SUPPORTER_LEVELS, on: :create
  validates :contact_name, presence: true, on: :create
  validates :street_address, presence: true, on: :create
  validates :address_region, presence: true, on: :create
  validates :address_country, presence: true, on: :create
  validates :postal_code, presence: true, on: :create
  validates :payment_method, presence: true, on: :create
  validates_acceptance_of :agreed_to_terms, on: :create

  validates_with OrganizationValidator, on: :create, unless: :individual?

  def remote?
    @remote || false
  end

  def remote!
    @remote = true
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

  def founding_partner?
    if founding_parter_id = ENV['FOUNDING_PARTNER_ID']
      membership_number == founding_parter_id
    end
  end

  def badge_class
    if %w[partner sponsor].include?(product_name)
      "partner"
    else
      "supporter"
    end
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
    self.name = value if individual?
  end

  def telephone=(value)
    @telephone = value
    self.phone = value if individual?
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
    Chargify::Product.all.each do |product|
      page = product.public_signup_pages.first
      if page
        register_chargify_product_link(product.handle, page.url)
      end
    end
  end

  def self.register_chargify_product_link(plan, url)
    CHARGIFY_PRODUCT_LINKS[plan] = url
  end

  def chargify_product_handle
    get_plan
  end

  def chargify_product_link(coupon=nil)
    if link = CHARGIFY_PRODUCT_LINKS[chargify_product_handle]
      url = URI(link)
      params = {
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
    update_attributes!({
      chargify_customer_id: params[:customer_id],
      chargify_subscription_id: params[:subscription_id],
      chargify_payment_id: params[:payment_id],
    }, without_protection: true)
  end

  def verify_chargify_subscription!(subscription, customer)
    verified = chargify_subscription_id == subscription['id'] &&
      chargify_customer_id == customer['id']
    if chargify_payment_id.present?
      verified = verified && chargify_payment_id == subscription['signup_payment_id']
    end
    self.update_attribute(:chargify_data_verified, verified)
  end

  def update_address_from_chargify(customer)
    self.street_address = customer['address']
    self.address_locality = customer['address_2']
    self.address_region = customer['city']
    self.address_country = customer['country']
    self.postal_code = customer['zip']
    set_address
    save!
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
      address_country,
      postal_code
    ].compact.join("\n")
  end

  after_create :setup_organization
  after_create :add_to_queue, unless: :remote?
  after_create :save_membership_id_in_capsule, if: :remote?

  def add_to_queue

    # construct hashes for signup processor
    # some of the naming of purchase order and membership id needs updating for consistency
    organization    = {
                        'name' => organization_name,
                        'vat_id' => organization_vat_id,
                        'company_number' => organization_company_number,
                        'size' => organization_size,
                        'type' => organization_type,
                        'sector' => organization_sector
                      }
    contact_person  = {'name' => contact_name, 'email' => email, 'telephone' => telephone}
    billing         = {
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
    purchase        = {
                        'payment_method' => payment_method,
                        'payment_ref' => chargify_payment_id,
                        'offer_category' => product_name,
                        'purchase_order_reference' => purchase_order_number,
                        'membership_id' => membership_number
                      }

    Resque.enqueue(SignupProcessor, organization, contact_person, billing, purchase)
  end

  def save_membership_id_in_capsule
    Resque.enqueue(SaveMembershipIdInCapsule, organization_name, membership_number)
  end

  def setup_organization
    self.create_organization(:name => organization_name) unless individual?
  end

  after_update :save_to_capsule, unless: :remote?

  def save_to_capsule
    if email_changed? || cached_newsletter_changed? || organization_size_changed? || organization_sector_changed?
      Resque.enqueue(SaveMembershipDetailsToCapsule, membership_number, {
        'email'      => email,
        'newsletter' => cached_newsletter,
        'size'       => organization_size,
        'sector'     => organization_sector
      })
    end
  end

  def get_plan
    if individual?
      'individual_supporter'
    else
      if LARGE_CORPORATE.include?(organization_size) && organization_type == 'commercial'
        'corporate_supporter_annual'
      else
        'supporter_annual'
      end
    end
  end

  def get_plan_description
    {
      'individual_supporter'            => 'individual supporter',
      'corporate_supporter_annual' => 'corporate supporter',
      'supporter_annual'                => 'supporter'
    }[get_plan]
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
    [
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
  end

  def set_defaults
    self.payment_method ||= "credit_card"
  end

end
