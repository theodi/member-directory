require 'active_support/concern'


module MemberListings
  extend ActiveSupport::Concern

  included do

    mount_uploader :organization_logo, ImageObjectUploader

    before_validation :strip_organization_name
    before_validation :strip_twitter_prefix
    before_validation :prefix_url

    attr_accessible :organization_name, :organization_description, :organization_url, :organization_logo, :organization_logo_cache,
                    :organization_contact_name, :organization_contact_phone, :organization_contact_email,
                    :organization_twitter, :organization_linkedin, :organization_facebook, :organization_tagline

    attr_accessible :organization_name, :organization_description, :organization_url, :organization_logo, :organization_logo_cache,
                    :organization_contact_name, :organization_contact_phone, :organization_contact_email,
                    :organization_twitter, :organization_linkedin, :organization_facebook, :organization_tagline,
                    as: [:admin, :user]

                    
    # We use both a URL-parsing validator, and a simple regexp here
    # so that we exclude things like http://localhost, which are valid
    # but undesirable
    validates :organization_url, :url => {:allow_nil => true}, :format => {:with => /\Ahttps?:\/\/([^\.\/]+?)\.([^\.\/]+?)/, :allow_nil => true}

    validates :organization_name, presence: true, uniqueness: true
    validates :organization_size, presence: true, inclusion: Member::ORGANISATION_SIZES.map{|k,v| v}, on: :create
    validates :organization_sector, presence: true, inclusion: Member::SECTORS, on: :create
    validates :organization_type, presence: true, inclusion: Member::ORGANISATION_TYPES.map{|k,v| v}, on: :create

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
      pluck(:organization_name).group_by {|name| alpha_group(name) }.keys.sort
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

    def prefix_url
      return if !self.organization_url.present? || self.organization_url =~ /^([a-z]+):\/\//

      self.organization_url = "http://#{self.organization_url}"
    end

    def character_limit
      supporter? ? 500 : 1000 
    end

  end

end