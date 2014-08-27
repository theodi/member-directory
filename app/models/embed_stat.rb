class EmbedStat < ActiveRecord::Base
  belongs_to :member

  validates :referrer, url: true

  attr_accessible :referrer
end
