class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  has_one :organization
  has_many :embed_stats

  accepts_nested_attributes_for :organization
  attr_accessible :organization_attributes

  before_create :set_membership_number

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

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
                  :payment_frequency,
                  :remote

  attr_accessor :organization_name,
                :organization_type,
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
                :payment_frequency

  attr_writer :remote

  # allow admins to edit access key
  attr_accessible :access_key, as: :admin

	# validations
  validates :product_name, presence: true, inclusion: %w(supporter member partner sponsor), on: :create
  validates :contact_name, presence: true, on: :create
  validates :organization_size, presence: true, inclusion: %w(<10 10-50 51-250 251-1000 >1000), on: :create
  validates :organization_sector, presence: true, on: :create
  validates :organization_type, presence: true, inclusion: %w(commercial non_commercial), on: :create
  validates :street_address, presence: true, on: :create
  validates :address_locality, presence: true, on: :create
  validates :address_country, presence: true, on: :create
  validates :postal_code, presence: true, on: :create
  validates :payment_method, presence: true, on: :create
  validates_acceptance_of :agreed_to_terms, on: :create

  after_validation :stripe_payment

  validate :check_organization_names

  def paid_with_card?
    payment_method == 'credit_card'
  end

  def remote
    @remote || false
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

  def organization_name=(value)
    @organization_name = value.try(:strip)
  end

  def stripe_customer
    Stripe::Customer.retrieve(stripe_customer_id) if stripe_customer_id
  end

  def product_name
    if ENV['FOUNDING_PARTNER_ID'] && membership_number == ENV['FOUNDING_PARTNER_ID']
      "Founding partner"
    else
      read_attribute(:product_name)
    end
  end

  def self.founding_partner_id
    ENV['FOUNDING_PARTNER_ID']
  end

  def register_embed(referrer)
    begin
      embed_stats.create(referrer: referrer)
    rescue ActiveRecord::RecordNotUnique
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

  after_create :add_to_queue, :setup_organization, :save_membership_id_in_capsule

  skip_callback :create, :after, :add_to_queue, :if => lambda { self.remote === true }
  skip_callback :create, :after, :save_membership_id_in_capsule, :unless => lambda { self.remote === true }

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
                        'payment_freq' => payment_frequency,
                        'payment_ref' => stripe_customer.try(:id),
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
    self.create_organization(:name => organization_name, :remote => remote)
  end

  after_update :save_to_capsule
  skip_callback :update, :after, :save_to_capsule, :if => lambda { self.remote === true }

  def save_to_capsule
    if unconfirmed_email_changed? || cached_newsletter_changed? || organization_size_changed? || organization_sector_changed?
      Resque.enqueue(SaveMembershipDetailsToCapsule, membership_number, {
        'email'      => unconfirmed_email || email,
        'newsletter' => cached_newsletter,
        'size'       => organization_size,
        'sector'     => organization_sector
      })
    end
  end

  def stripe_payment
    if new_record? && paid_with_card? && errors.empty?
      begin
        set_membership_number
        customer = Stripe::Customer.create(
          card: {
            exp_month: card_expiry_month,
            exp_year:  card_expiry_year,
            number:    card_number,
            cvc:       card_validation_code
          },
          plan:        get_plan,
          description: "#{organization_name} #{get_plan_description} membership (#{membership_number})"
        )
        self.stripe_customer_id = customer.id
      rescue Stripe::CardError => e
        body = e.json_body
        payment_errors(body[:error])
      end
    end
  end

  def get_plan
    plan = ''
    if %w{251-1000 >1000}.include?(organization_size) && organization_type == 'commercial'
      plan += 'corporate_'
    end
    plan += 'supporter_'
    plan += payment_frequency
  end

  def get_plan_description
    {
      'corporate_supporter_monthly' => 'corporate supporter',
      'supporter_monthly'           => 'supporter',
      'corporate_supporter_annual'  => 'corporate supporter',
      'supporter_annual'            => 'supporter'
    }[get_plan]
  end

  def payment_errors(err)
    case err[:code]
    when 'incorrect_number'
      errors.add(:card_number, 'is incorrect')
    when 'incorrect_cvc'
      errors.add(:card_validation_code, 'is incorrect')
    when 'invalid_number'
      errors.add(:card_number, 'is incorrect')
    when 'invalid_expiry_month'
      errors.add(:card_expiry_month, 'is incorrect')
    when 'invalid_expiry_year'
      errors.add(:card_expiry_year, 'is incorrect')
    when 'invalid_cvc'
      errors.add(:card_validation_code, 'is incorrect')
    when 'expired_card'
      errors.add(:card_number, 'has expired')
    when 'card_declined'
      errors.add(:card_number, 'has been declined')
    # when 'missing'
    # 	There is no card on a customer that is being charged.
    # when 'processing_error'
    # 	An error occurred while processing the card.
    # when 'rate_limit'
    #   Rate limit was hit
    end
  end

  def country_name
    country = ISO3166::Country[address_country]
    return "" if country.nil?
    country.translations[I18n.locale.to_s] || country.name
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
  
end
