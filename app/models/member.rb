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
  attr_accessible :email, :password, :password_confirmation, :remember_me, :product_name
  attr_accessible :organization_name, :contact_name, :telephone, :street_address,
									:address_locality, :address_region, :address_country,
									:postal_code, :organization_vat_id, :purchase_order_number, :agreed_to_terms
  attr_accessor   :organization_name, :contact_name, :telephone, :street_address,
									:address_locality, :address_region, :address_country,
									:postal_code, :organization_vat_id, :purchase_order_number, :agreed_to_terms

	# validations
	validates :product_name, :presence => true, :inclusion => %w{supporter member partner sponsor}, :on => :create
	validates :contact_name, :presence => true, :on => :create
	validates :street_address, :presence => true, :on => :create
	validates :address_locality, :presence => true, :on => :create
	validates :address_country, :presence => true, :on => :create
	validates :postal_code, :presence => true, :on => :create
	validates_acceptance_of :agreed_to_terms, :on => :create
	
  validate :check_organization_names
  
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

  after_create :add_to_queue, :setup_organization
  
  def add_to_queue
    
    # construct hashes for signup processor
    # some of the naming of purchase order and membership id needs updating for consistency
    organization    = {'name' => organization_name, 'vat_id' => organization_vat_id}
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

  def setup_organization
    self.create_organization(:name => organization_name)
  end

end
