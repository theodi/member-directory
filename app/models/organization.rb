class Organization < ActiveRecord::Base
  belongs_to :member, :foreign_key => 'membership_number'
  
  attr_accessible :name, :description, :url, :email
  attr_accessor :description, :url, :email
  
  validates :name, :presence => true
end
