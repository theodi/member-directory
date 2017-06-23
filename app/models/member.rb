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
    student
  ]

  CURRENT_SUPPORTER_LEVELS = %w[
    supporter
    individual
    student
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
    "Aberdeen" => "odi-aberdeen",
    "Athens" => "odi-athens",
    "Belfast" => "odi-belfast",
    "Birmingham" => "odi-birmingham",
    "Brasilia" => "odi-brasilia",
    "Bristol" => "odi-bristol",
    "Cairo" => "odi-cairo",
    "Cardiff" => "odi-cardiff",
    "Cornwall" => "odi-cornwall",
    "Devon" => "odi-devon",
    "Dubai" => "odi-dubai",
    "Galway" => "odi-galway",
    "Gothenburg" => "odi-gothenburg",
    "Hampshire" => "odi-hampshire",
    "Leeds" => "odi-leeds",
    "Madrid" => "odi-madrid",
    "Osaka" => "odi-osaka",
    "Paris" => "odi-paris",
    "Queensland" => "odi-queensland",
    "Rio" => "odi-rio",
    "Rome" => "odi-rome",
    "Riyadh" => "odi-riyadh",
    "Seoul" => "odi-seoul",
    "St Petersburg" => "odi-st-petersburg",
    "Toronto" => "odi-toronto",
    "Trento" => "odi-trento",
    "Vienna" => "odi-vienna"
  }

  LARGE_CORPORATE = %w[251-1000 >1000]

  SUBSCRIPTION_OPTIONS = {
    choices: [1,2,5,10,20,30,40,50,60,70,80,90,100],
    default: 30
  }

  has_one :listing, dependent: :destroy
  has_many :embed_stats

  accepts_nested_attributes_for :listing
  attr_accessible :listing_attributes

  before_create :set_membership_number, :set_address
  after_create  :setup_listing

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :product_name,
                  :newsletter,
                  :share_with_third_parties,
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
                  :invoice,
                  :university_email,
                  :university_country,
                  :university_address_country,
                  :university_name,
                  :university_name_other,
                  :university_course_name,
                  :university_qualification,
                  :university_qualification_other,
                  :university_course_start_date_year,
                  :university_course_start_date_month,
                  :university_course_end_date_year,
                  :university_course_end_date_month,
                  :twitter,
                  :dob_day,
                  :dob_month,
                  :dob_year,
                  :subscription_amount,
                  :login # non-DB field

  # Copying all this is terrible, but it will get tidier later
  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :product_name,
                  :newsletter,
                  :share_with_third_parties,
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
                  :invoice,
                  :university_email,
                  :university_country,
                  :university_address_country,
                  :university_name,
                  :university_name_other,
                  :university_course_name,
                  :university_qualification,
                  :university_qualification_other,
                  :university_course_start_date_year,
                  :university_course_start_date_month,
                  :university_course_end_date_year,
                  :university_course_end_date_month,
                  :twitter,
                  :dob_day,
                  :dob_month,
                  :dob_year,
                  :subscription_amount,
                  :as => :admin

  attr_accessor :agreed_to_terms
  attr_accessor :university_course_start_date_year
  attr_accessor :university_course_start_date_month
  attr_accessor :university_course_end_date_year
  attr_accessor :university_course_end_date_month
  attr_accessor :dob_day
  attr_accessor :dob_month
  attr_accessor :dob_year

  attr_accessor :no_payment

  before_validation :normalize_dob
  before_validation :normalize_course_start_date
  before_validation :normalize_course_end_date

  def normalize_dob
    return unless dob_day.present? && dob_month.present? && dob_year.present?

    self.dob = Date.parse("#{dob_year}/#{dob_month}/#{dob_day}")
  rescue ArgumentError
    errors.add(:dob, "is not a valid date")
  end

  def normalize_course_start_date
    return unless university_course_start_date_year.present? && university_course_start_date_month.present?

    self.university_course_start_date = Date.parse("#{university_course_start_date_year}/#{university_course_start_date_month}/01")
  rescue ArgumentError
    errors.add(:university_course_start_date, "is not a valid date")
  end

  def normalize_course_end_date
    return unless university_course_end_date_year.present? && university_course_end_date_month.present?

    self.university_course_end_date   = Date.parse("#{university_course_end_date_year}/#{university_course_end_date_month}/01")
  rescue ArgumentError
    errors.add(:university_course_end_date, "is not a valid date")
  end

  # allow admins to edit access key
  attr_accessible :access_key, as: :admin

  # validations
  validates :product_name, presence: true, inclusion: SUPPORTER_LEVELS, on: :create
  validates :contact_name, presence: true, on: :create
  validates :street_address, presence: true, on: :create
  validates :address_region, presence: true, on: :create
  validates :address_country, presence: true, on: :create
  validates :postal_code, presence: true, on: :create
  validates :subscription_amount, presence: true, on: :create, if: Proc.new { |member| member.individual? && member.coupon.nil? }
  validates_acceptance_of :agreed_to_terms, on: :create

  validates_with OrganizationValidator, on: :create, unless: Proc.new { |member| member.individual? || member.student? }

  validates :university_email,               presence: true, if: Proc.new { |member| member.student? }
  validates :university_name,                presence: true, if: Proc.new { |member| member.student? }
  validates :university_name_other,          presence: true, if: Proc.new { |member| member.student? && member.university_name == "Other (please specify)" }
  validates :university_course_name,         presence: true, if: Proc.new { |member| member.student? }
  validates :university_qualification,       presence: true, if: Proc.new { |member| member.student? }
  validates :university_qualification_other, presence: true, if: Proc.new { |member| member.student? && member.university_qualification == "Other (please specify)" }
  validates :university_course_start_date,   presence: true, if: Proc.new { |member| member.student? }
  validates :university_course_end_date,     presence: true, if: Proc.new { |member| member.student? }
  validates :dob,                            presence: true, if: Proc.new { |member| member.student? }

  scope :current, where(:current => true)
  scope :valid, where('product_name is not null')

  def self.founding_partner_id
    ENV['FOUNDING_PARTNER_ID']
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(membership_number) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_hash).first
    end
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

  def self.subscription_options
    SUBSCRIPTION_OPTIONS[:choices]
  end

  def self.default_subscription_option
    SUBSCRIPTION_OPTIONS[:default]
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

  def current!
    update_attribute(:active, true) if organization?
    update_attribute(:current, true)
  end

  def self.create_without_password!(options = {})
    temp_password = SecureRandom.hex(32)
    from_capsule = options.delete(:from_capsule)
    member = Member.new(options.merge(
      password: temp_password,
      password_confirmation: temp_password
    ))
    member.remote! if from_capsule
    member.send :generate_reset_password_token
    member.current = true
    member.save(:validate => from_capsule ? false : true)
    # Send onwards and let the customer know
    member.deliver_welcome_email!
    member
  end

  def deliver_welcome_email!
    send_devise_notification(:confirmation_instructions)
  end

  def check_organization_names
    if new_record? # Only validate on create
      unless Listing.where(:name => organization_name).empty?
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
    # TODO This is weird, why does this one check use a class method?
    self.class.is_individual_level?(product_name)
  end

  def student?
    product_name == "student"
  end

  def no_payment?
    no_payment
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
    if founding_partner_id = self.class.founding_partner_id
      membership_number == founding_partner_id
    end
  end

  def abandoned_signup?
    errors.messages[:email] && errors.messages[:email].include?("has already been taken") && !current?
  end

  def badge_class
    if %w[partner sponsor].include?(product_name)
      "partner"
    else
      "supporter"
    end
  end

  def organization_name
    listing.try(:name) || @organization_name
  end

  def organization_name=(value)
    @organization_name = value.try(:strip)
  end

  def contact_name
    @contact_name || name.presence
  end

  def first_name
    contact_name.to_s.split(/\s+/, 2).first
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
    elsif student?
      "Student Supporter"
    else
      "Supporter"
    end
  end

  def unsubscribe_from_newsletter!
    self.update_attribute(:newsletter, false)
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
      'individual-supporter-new' => 'Individual Supporter',
      'individual-supporter-student' => 'ODI Student Supporter',
      'corporate-supporter_annual'   => 'Corporate Supporter',
      'supporter_annual'             => 'Supporter',
      'supporter_monthly'            => 'Supporter'
    }[plan]
  end

  def invoiced?
    self.invoice == true
  end

  def plan
    if individual?
      'individual-supporter-new'
    elsif student?
      'individual-supporter-student'
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

  def setup_listing
    return unless organization?

    self.create_listing(:name => organization_name)
  end

  def country_name
    country = ISO3166::Country[address_country]
    return "" if country.nil?
    country.translations[I18n.locale.to_s] || country.name
  end
    
  def organization_type_enum
    Member::ORGANISATION_TYPES.to_a
  end
  
end
