class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  has_one :organization
  accepts_nested_attributes_for :organization
  attr_accessible :organization_attributes

  before_create :set_membership_number

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :product_name, :cached_newsletter
  attr_accessible :organization_name, :organization_size, :organization_type, :contact_name,
                  :telephone, :street_address, :address_locality, :address_region,
                  :address_country, :postal_code, :organization_vat_id, :organization_company_number,
                  :purchase_order_number, :agreed_to_terms, :remote
  attr_accessor   :organization_name, :organization_size, :organization_type, :contact_name,
                  :telephone, :street_address, :address_locality, :address_region,
                  :address_country, :postal_code, :organization_vat_id, :organization_company_number,
                  :purchase_order_number, :agreed_to_terms
  attr_writer     :remote

  # allow admins to edit access key
  attr_accessible :access_key, as: :admin

	# validations
	validates :product_name, :presence => true, :inclusion => %w{supporter member partner sponsor}, :on => :create
	validates :contact_name, :presence => true, :on => :create
  validates :organization_size, :presence => true, :inclusion => %w{small large}, :on => :create
  validates :organization_type, :presence => true, :inclusion => %w{commercial non_commercial}, :on => :create
	validates :street_address, :presence => true, :on => :create
	validates :address_locality, :presence => true, :on => :create
	validates :address_country, :presence => true, :on => :create
	validates :postal_code, :presence => true, :on => :create
	validates_acceptance_of :agreed_to_terms, :on => :create

  validate :check_organization_names

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

	private

  def generate_membership_number
    chars = ('A'..'Z').to_a
    chars.sample + chars.sample + "%04d" % SecureRandom.random_number(9999) + chars.sample + chars.sample
  end

  def set_membership_number
    begin
      self.membership_number = generate_membership_number
    end while self.class.exists?(:membership_number => membership_number)
  end

  after_create :add_to_queue, :setup_organization, :save_membership_id_in_capsule

  skip_callback :create, :after, :add_to_queue, :if => lambda { self.remote === true }
  skip_callback :create, :after, :save_membership_id_in_capsule, :unless => lambda { self.remote === true }

  def add_to_queue

    # construct hashes for signup processor
    # some of the naming of purchase order and membership id needs updating for consistency
    organization    = {'name' => organization_name, 'vat_id' => organization_vat_id, 'company_number' => organization_company_number}
    contact_person  = {'name' => contact_name, 'email' => email, 'telephone' => telephone}
    billing         = {
                        'name' => contact_name,
                        'email' => email,
                        'telephone' => telephone,
                        'address' => {
                          'street_address' => street_address,
                          'address_locality' => address_locality,
                          'address_region' => address_region,
                          'address_country' => address_country,
                          'postal_code' => postal_code
                        }
                      }
    purchase        = {
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
    if unconfirmed_email_changed? || cached_newsletter_changed?
      Resque.enqueue(SaveMembershipDetailsToCapsule, membership_number, {
        'email'      => unconfirmed_email || email,
        'newsletter' => cached_newsletter
      })
    end
  end

end
