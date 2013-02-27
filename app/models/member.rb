class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  
  before_create :set_membership_number
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :level, :organisation_name, :contact_name, :phone, :address_line1,
									:address_line2, :address_city, :address_region, :address_country,
									:address_postcode, :tax_number, :purchase_order_number, :agreed_to_terms
  attr_accessor :level, :organisation_name, :contact_name, :phone, :address_line1,
									:address_line2, :address_city, :address_region, :address_country,
									:address_postcode, :tax_number, :purchase_order_number, :agreed_to_terms

	# validations
	validates :level, :presence => true
	validates :contact_name, :presence => true
	validates :address_line1, :presence => true
	validates :address_city, :presence => true
	validates :address_country, :presence => true
	validates :address_postcode, :presence => true
	validates_acceptance_of :agreed_to_terms
	
	private
	
	 def generate_membership_number
  	 "%010d" % SecureRandom.random_number(9999999999)
	 end
	
	 def set_membership_number
	   begin 
	     self.membership_number = generate_membership_number
	   end while self.class.exists?(:membership_number => membership_number)
	 end

  after_create :add_to_queue
  
  def add_to_queue
    
    # construct hashes for signup processor
    # some of the naming of purchase order and membership id needs updating for consistency
    organization    = {'name' => organisation_name, 'vat_id' => tax_number}
    contact_person  = {'name' => contact_name, 'email' => email, 'telephone' => phone}
    billing         = {
                        'name' => contact_name,
                        'email' => email,
                        'telephone' => phone,
                        'address' => {
                          'street_address' => address_line1,
                          'address_locality' => address_city,
                          'address_region' => address_region,
                          'address_country' => address_country,
                          'postal_code' => address_postcode
                        }
                      }
    purchase        = {
                        'offer_category' => level,
                        'purchase_order_reference' => purchase_order_number,
                        'membership_id' => membership_number
                      }

    Resque.enqueue(SignupProcessor, organization, contact_person, billing, purchase)
  end

end