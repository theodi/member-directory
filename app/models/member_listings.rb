require 'active_support/concern'


module MemberListings
  extend ActiveSupport::Concern

  included do

    before_validation :strip_organization_name
    before_validation :strip_twitter_prefix

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

    def self.founding_partner_id
      ENV['FOUNDING_PARTNER_ID']
    end

    def strip_organization_name
      organization_name.try(:strip!)
    end

    def self.in_alpha_group(alpha)
      if alpha.upcase.between?('A', 'Z')
        where("substr(organization_name, 1, 1) = ?", alpha)
      else
        letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        where("instr('#{letters}', substr(organization_name, 1, 1)) = 0")
      end
    end

    def self.alpha_groups
      pluck(:name).group_by {|name| alpha_group(name) }.keys.sort
    end

    def self.alpha_group(name)
      letter = name.upcase.first
      letter.between?('A', 'Z') ? letter : '#'
    end

    # Sorry, ActiveRecord can't quite make this query
    # should work in both MySQL and sqlite
    scope :display_order, order(<<-ORDER)
      membership_number = '#{connection.quote_string(founding_partner_id)}' desc,
      case product_name
        when 'partner' then 1
        when 'sponsor' then 2
        when 'member' then 3
        when 'supporter' then 4
        else 5
      end,
      organization_name
    ORDER

    def strip_twitter_prefix
      self.organization_twitter = organization_twitter.last(-1) if organization_twitter.try(:starts_with?, '@')
    end

    def twitter_url
      organization_twitter ? "https://twitter.com/#{organization_twitter}" : nil
    end


  end

end