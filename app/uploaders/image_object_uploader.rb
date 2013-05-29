# encoding: utf-8

class ImageObjectUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  
  process :convert => 'png'
  
  storage :fog
  #storage :file

  def store_dir
    "logos/#{model.member.membership_number}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "original.png" if original_filename
  end

  version :rectangular do
    process :resize_to_fit => [200,100]
    def full_filename (for_file = model.member.logo)
      "rectangular.png"
    end
  end

  version :square do
    process :resize_to_fit => [100,100]
    def full_filename (for_file = model.member.logo)
      "square.png"
    end
  end

end