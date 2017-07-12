require 'active_support/concern'


module MemberListings
  extend ActiveSupport::Concern

  included do

    before_validation :strip_organization_name

    attr_accessible :organization_name, :organization_description, :organization_url, :organization_logo, :organization_logo_cache,
                    :organization_contact_name, :organization_contact_phone, :organization_contact_email,
                    :organization_twitter, :organization_linkedin, :organization_facebook, :organization_tagline

    attr_accessible :organization_name, :organization_description, :organization_url, :organization_logo, :organization_logo_cache,
                    :organization_contact_name, :organization_contact_phone, :organization_contact_email,
                    :organization_twitter, :organization_linkedin, :organization_facebook, :organization_tagline,
                    as: [:admin, :user]

    validates :organization_name, presence: true, uniqueness: true
    validates :organization_size, presence: true, inclusion: Member::ORGANISATION_SIZES.map{|k,v| v}
    validates :organization_sector, presence: true, inclusion: Member::SECTORS
    validates :organization_type, presence: true, inclusion: Member::ORGANISATION_TYPES.map{|k,v| v}

    validates :organization_description, :presence => true, :on => :update
    validates :organization_description, :length => { :maximum  => 500, :too_long => "Your description cannot be longer than %{count} characters"}, :if => :supporter?
    validates :organization_description, :length => { :maximum  => 1000, :too_long => "Your description cannot be longer than %{count} characters"}, :unless => :supporter?

    def strip_organization_name
      organization_name.try(:strip!)
    end

  end

end