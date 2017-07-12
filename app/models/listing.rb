class Listing < ActiveRecord::Base
  belongs_to :member

  mount_uploader :logo, ImageObjectUploader

  # Using after_save here so we get the right image urls
  before_validation :prefix_url

  # We use both a URL-parsing validator, and a simple regexp here
  # so that we exclude things like http://localhost, which are valid
  # but undesirable
  validates :url, :url => {:allow_nil => true}, :format => {:with => /\Ahttps?:\/\/([^\.\/]+?)\.([^\.\/]+?)/, :allow_nil => true}

  def supporter?
    member.supporter?
  end

  def membership_description
    member.membership_description
  end

  def character_limit
    supporter? ? 500 : 1000 
  end

  def prefix_url
    return if !self.url.present? || self.url =~ /^([a-z]+):\/\//

    self.url = "http://#{self.url}"
  end

end

