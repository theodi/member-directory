class EmbedStat < ActiveRecord::Base
  belongs_to :member

  validates :referrer, url: true

  attr_accessible :referrer

  def self.csv
    CSV.generate(row_sep: "\r\n") do |csv|
      csv << ["Member Name", "Referring URL", "First Detected"]
      all.each { |s| csv << [s.member.listing.name, s.referrer, s.created_at] }
    end
  end

end
