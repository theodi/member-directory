# encoding: utf-8

class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  include MemberConstants
  include MemberAdmin
  include MemberListings

  has_many :embed_stats

  before_create :set_membership_number, :set_address

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
                  
  attr_accessor :agreed_to_terms

  # validations
  validates :product_name, presence: true, inclusion: SUPPORTER_LEVELS, on: :create
  validates :contact_name, presence: true, on: :create
  validates :street_address, presence: true, on: :create
  validates :address_region, presence: true, on: :create
  validates :address_country, presence: true, on: :create
  validates :postal_code, presence: true, on: :create
  validates_acceptance_of :agreed_to_terms, on: :create  

  scope :current, -> { where(:current => true) }
  scope :valid, -> { where('product_name is not null') }

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
    update_attribute(:active, true)
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

  def to_param
    membership_number
  end

  def supporter?
    product_name == "supporter"
  end

  def large_corporate_organization?
    LARGE_CORPORATE.include?(organization_size) && organization_type == 'commercial'
  end

  def monthly_payment_option?
    !large_corporate_organization?
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
    else
      product_name.titleize
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
      'corporate-supporter_annual'   => 'Corporate Supporter',
      'supporter_annual'             => 'Supporter',
      'supporter_monthly'            => 'Supporter'
    }[plan]
  end

  def plan
    if large_corporate_organization?
      'corporate-supporter_annual'
    else
      'supporter_annual'
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

  def country_name
    country = ISO3166::Country[address_country]
    return "" if country.nil?
    country.translations[I18n.locale.to_s] || country.name
  end
    
end
