class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
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

end
