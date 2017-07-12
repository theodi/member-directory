class Listing < ActiveRecord::Base
  belongs_to :member

  mount_uploader :logo, ImageObjectUploader

  def supporter?
    member.supporter?
  end

  def membership_description
    member.membership_description
  end

  def character_limit
    supporter? ? 500 : 1000 
  end

end

