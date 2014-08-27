class EmbedStat < ActiveRecord::Base
  has_one :member

  validates :referrer, url: true
  
  attr_accessible :referrer
end
