class EmbedStat < ApplicationRecord
  belongs_to :member

  validates :referrer, url: true

  def self.csv
    CSV.generate(row_sep: "\r\n") do |csv|
      csv << ["Member Name", "Referring URL", "First Detected"]
      all.each { |s| csv << [s.member.organization_name, s.referrer, s.created_at] }
    end
  end

end
