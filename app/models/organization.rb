class Organization < ActiveRecord::Base
  belongs_to :member

  mount_uploader :logo, ImageObjectUploader

  attr_accessible :name, :description, :url, :logo, :logo_cache,
                  :cached_contact_name, :cached_contact_phone, :cached_contact_email,
                  :cached_twitter, :cached_linkedin, :cached_facebook, :cached_tagline

  # Using after_save here so we get the right image urls
  before_save :strip_twitter_prefix
  before_validation :prefix_url

  validates :name, :presence => true, :on => :update
  validates :name, :uniqueness => true, :allow_nil => true
  validates :description, :presence => true, :on => :update
  validates :description, :length => { :maximum  => 500, :too_long => "Your description cannot be longer than %{count} characters"}, :if => :supporter?
  validates :description, :length => { :maximum  => 1000, :too_long => "Your description cannot be longer than %{count} characters"}, :unless => :supporter?

  # We use both a URL-parsing validator, and a simple regexp here
  # so that we exclude things like http://localhost, which are valid
  # but undesirable
  validates :url, :url => {:allow_nil => true}, :format => {:with => /\Ahttps?:\/\/([^\.\/]+?)\.([^\.\/]+?)/, :allow_nil => true}

  scope :active, joins(:member).where(:members => { :cached_active => true })
  scope :for_level, lambda { |level| joins(:member).where(members: { product_name: level}) }

  # Sorry, ActiveRecord can't quite make this query
  # should work in both MySQL and sqlite
  scope :display_order, joins(:member).order(<<-ORDER)
    members.membership_number = '#{connection.quote_string(Member.founding_partner_id)}' desc,
    case members.product_name
      when 'partner' then 1
      when 'sponsor' then 2
      when 'member' then 3
      when 'supporter' then 4
      else 5
    end,
    organizations.name
  ORDER

  def self.in_alpha_group(alpha)
    if alpha.upcase.between?('A', 'Z')
      where("substr(organizations.name, 1, 1) = ?", alpha)
    else
      letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      where("instr('#{letters}', substr(organizations.name, 1, 1)) = 0")
    end
  end

  def self.alpha_groups
    pluck(:name).group_by {|name| alpha_group(name) }.keys.sort
  end

  def self.alpha_group(name)
    letter = name.upcase.first
    letter.between?('A', 'Z') ? letter : '#'
  end

  def supporter?
    member.supporter?
  end

  def membership_description
    member.membership_description
  end

  def character_limit
    supporter? ? 500 : 1000 
  end

  def strip_twitter_prefix
    self.cached_twitter = self.cached_twitter.last(-1) if self.cached_twitter.try(:starts_with?, '@')
  end

  def prefix_url
    return if !self.url.present? || self.url =~ /^([a-z]+):\/\//

    self.url = "http://#{self.url}"
  end

  def twitter_url
    cached_twitter ? "http://twitter.com/#{cached_twitter}" : nil
  end
end

