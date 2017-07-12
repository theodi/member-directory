require 'active_support/concern'


module MemberListings
  extend ActiveSupport::Concern

  included do

    has_one :listing, dependent: :destroy

    accepts_nested_attributes_for :listing
    attr_accessible :listing_attributes

    after_create  :setup_listing

    def check_organization_names
      if new_record? # Only validate on create
        unless Listing.where(:name => organization_name).empty?
          errors.add(:organization_name, "is already taken")
        end
      end
    end

    def organization_name
      listing.try(:name) || @organization_name
    end

    def organization_name=(value)
      @organization_name = value.try(:strip)
    end

    private

    def setup_listing
      self.create_listing(:name => organization_name)
    end
      
  end

end