class EmbedStat < ActiveRecord::Base
  has_one :member

  attr_accessible :referrer

end
