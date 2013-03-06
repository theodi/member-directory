class Organization < ActiveRecord::Base
  belongs_to :member
  
  attr_accessible :name, :description, :url, :email
  attr_accessor :description, :url, :email
  
  validates :name, :presence => true
end
