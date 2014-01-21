class Organization < ActiveRecord::Base
  belongs_to :member
  
  mount_uploader :logo, ImageObjectUploader
  
  attr_accessible :name, :description, :url, :logo, :logo_cache, :remote,
                  :cached_contact_name, :cached_contact_phone, :cached_contact_email,
                  :cached_twitter, :cached_linkedin, :cached_facebook, :cached_tagline
  
  attr_writer     :remote
  
  # Using after_save here so we get the right image urls
  before_save :strip_twitter_prefix, :strip_spaces
  after_save :send_to_capsule
  skip_callback :save, :after, :send_to_capsule, :if => lambda { self.remote === true }
  
  validates :name, :presence => true, :on => :update
  validates :name, :uniqueness => true, :allow_nil => true
  validates :description, :presence => true, :on => :update
  validates :description, :length => { :maximum  => 500, :too_long => "Your description cannot be longer than %{count} characters"}, :if => :supporter?
  validates :description, :length => { :maximum  => 1000, :too_long => "Your description cannot be longer than %{count} characters"}, :if => :member?

  # We use both a URL-parsing validator, and a simple regexp here
  # so that we exclude things like http://localhost, which are valid
  # but undesirable
  validates :url, :url => {:allow_nil => true}, :format => {:with => /\Ahttps?:\/\/([^\.\/]+?)\.([^\.\/]+?)/, :allow_nil => true}
  
  def remote
    @remote || false
  end

  def member?
    self.member.product_name == "member"
  end

  def supporter?
    self.member.product_name == "supporter"
  end
  
  def character_limit
    supporter? ? 500 : 1000 
  end
    
  def strip_twitter_prefix
    self.cached_twitter = self.cached_twitter.last(-1) if self.cached_twitter.try(:starts_with?, '@')
  end

  def strip_spaces
    self.name.try(:strip!)
  end
    
  def send_to_capsule
    if valid? && changed?
      organization = {
        :name => name
      }
  
      directory_entry = {
        :description => description,
        :homepage    => url,
        :logo        => logo.url,
        :thumbnail   => logo.square.url,
        :contact     => cached_contact_name,
        :phone       => cached_contact_phone,
        :email       => cached_contact_email,
        :twitter     => cached_twitter,
        :linkedin    => cached_linkedin,
        :facebook    => cached_facebook,
        :tagline     => cached_tagline,
      }
  
      date = updated_at.to_s
    
      Resque.enqueue(SendDirectoryEntryToCapsule, member.membership_number, organization, directory_entry, date)
    end
  end

  def twitter_url
    cached_twitter ? "http://twitter.com/#{cached_twitter}" : nil
  end
  
end
