require 'active_support/concern'


module MemberAdmin
  extend ActiveSupport::Concern

  included do

    # Copying all this is terrible, but it will get tidier later
    attr_accessible :email,
                    :password,
                    :password_confirmation,
                    :membership_number,
                    :product_name,
                    :active,
                    :newsletter,
                    :organization_sector,
                    :organization_size,
                    :name,
                    :phone,
                    :street_address,
                    :address_locality,
                    :address_region,
                    :address_country,
                    :postal_code,
                    :organization_type,
                    :organization_company_number,
                    :current,
                    :origin,
                    :share_with_third_parties,
                    :twitter,
                    :organization_name,
                    :organization_description,
                    :organization_url,
                    :organization_contact_name,
                    :organization_contact_phone,
                    :organization_contact_email,
                    :organization_twitter,
                    :organization_facebook,
                    :organization_linkedin,
                    :organization_tagline,
                    :as => :admin

    rails_admin do
      
      list do
        field :membership_number
        field :name
        field :organization_name
        field :product_name
        field :active
      end

      create do

        field :email do
          label "Login email address"
        end
        field :password
        field :password_confirmation do
          required true
        end
        field :membership_number do
          required true
        end
        field :product_name
        field :organization_name
        field :organization_type
        field :organization_size
        field :organization_sector

        field :street_address
        field :address_locality
        field :address_region
        field :address_country
        field :postal_code

        field :organization_description
        field :organization_url
        field :organization_contact_name
        field :organization_contact_phone
        field :organization_contact_email
        field :organization_twitter
        field :organization_facebook
        field :organization_linkedin
        field :organization_tagline

        field :name do
          label "Membership admin email address"
        end
        field :phone do
          label "Membership admin phone number"
        end

        field :origin
        field :newsletter
        field :share_with_third_parties
        field :organization_company_number

        field :active
        field :current

      end
      
      edit do
        field :email do
          label "Login email address"
        end
        field :product_name
        field :organization_name
        field :organization_type
        field :organization_size
        field :organization_sector

        field :street_address
        field :address_locality
        field :address_region
        field :address_country
        field :postal_code

        field :organization_description
        field :organization_url
        field :organization_contact_name
        field :organization_contact_phone
        field :organization_contact_email
        field :organization_twitter
        field :organization_facebook
        field :organization_linkedin
        field :organization_tagline

        field :name do
          label "Membership admin email address"
        end
        field :phone do
          label "Membership admin phone number"
        end

        field :origin
        field :newsletter
        field :share_with_third_parties
        field :organization_company_number

        field :active
        field :current
      end
    end
    
    def organization_type_enum
      Member::ORGANISATION_TYPES.to_a
    end

    def organization_size_enum
      Member::ORGANISATION_SIZES.to_a
    end
      
    def product_name_enum
      Member::SUPPORTER_LEVELS.to_a
    end
  
    def organization_sector_enum
      Member::SECTORS.to_a
    end

    def origin_enum
      Member::ORIGINS.to_a
    end

  end
    
end
