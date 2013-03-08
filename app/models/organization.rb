class Organization < ActiveRecord::Base
  belongs_to :member
  
  mount_uploader :logo, ImageObjectUploader
  
  attr_accessible :name, :description, :url, :logo, :logo_cache
  
  validates :name, :presence => true, :on => :update
  validates :description, :presence => true, :on => :update
  validates :description, :length => { :maximum  => 500, :too_long => "Your description cannot be longer than %{count} characters"}, :if => :supporter?
  validates :description, :length => { :maximum  => 1000, :too_long => "Your description cannot be longer than %{count} characters"}, :if => :member?

  # We use both a URL-parsing validator, and a simple regexp here
  # so that we exclude things like http://localhost, which are valid
  # but undesirable
  validates :url, :url => {:allow_nil => true}, :format => {:with => /^https?:\/\/([^\.\/]+?)\.([^\.\/]+?)/, :allow_nil => true}
  
  def member?
    self.member.product_name == "member"
  end

  def supporter?
    self.member.product_name == "supporter"
  end
  
  def character_limit
    self.member.product_name == "supporter" ? 500 : 1000 
  end
end
