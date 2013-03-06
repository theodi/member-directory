class Organization < ActiveRecord::Base
  belongs_to :member
  
  mount_uploader :logo, ImageObjectUploader
  
  attr_accessible :name, :description, :url, :email, :logo, :logo_cache
  attr_accessor :description, :url, :email
  
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
end
