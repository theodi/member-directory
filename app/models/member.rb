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
	
	 def set_membership_number
	   begin 
	     self.membership_number = (0...1000000).sort_by{rand}.first
	   end while self.class.exists?(:membership_number => membership_number)
	 end

  after_create :add_to_queue
  
  def add_to_queue
    user_details =  {
      :level                 => level,
      :organisation_name     => organisation_name,
      :contact_name          => contact_name,
      :email                 => email,
      :phone                 => phone, 
      :address_line1         => address_line1, 
      :address_line2         => address_line2, 
      :address_city          => address_city, 
      :address_region        => address_region, 
      :address_country       => address_country, 
      :address_postcode      => address_postcode, 
      :tax_number            => tax_number, 
      :purchase_order_number => purchase_order_number
    }    
    Resque.enqueue(SignupProcessor, user_details)
  end

end
