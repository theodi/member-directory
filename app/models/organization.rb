class Organization < ActiveRecord::Base
  belongs_to :member
  
  mount_uploader :logo, ImageObjectUploader
  
  attr_accessible :name, :description, :url, :logo, :logo_cache
  
  validates :name, :presence => true, :on => :update
  validates :description, :presence => true, :on => :update
  validates :description, :length => { :maximum  => 500, :too_long => "Your description cannot be longer than %{count} characters"}, :if => :supporter?
  validates :description, :length => { :maximum  => 1000, :too_long => "Your description cannot be longer than %{count} characters"}, :if => :member?
  
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
