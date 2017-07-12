require 'active_support/concern'


module MemberAdmin
  extend ActiveSupport::Concern

  included do

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
                    :organization_company_number,
                    :agreed_to_terms,
                    :address,
                    :origin,
                    :twitter,
                    :as => :admin

    rails_admin do
    
    end

    # allow admins to edit access key
    attr_accessible :access_key, as: :admin
    
    def organization_type_enum
      Member::ORGANISATION_TYPES.to_a
    end

    def organization_size_enum
      Member::ORGANISATION_SIZES.to_a
    end
      
    def product_name_enum
      Member::SUPPORTER_LEVELS.to_a
    end
  
  end
    
end
