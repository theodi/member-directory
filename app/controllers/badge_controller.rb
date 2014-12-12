class BadgeController < ApplicationController

  before_filter :set_formats, :only => [:logo]

  def logo
    render "logos/#{badge_type}-#{badge_size}", format: :svg
  end

  def badge
    asset = "badges/#{badge_colour}/#{badge_image_size}.png"
    filename = "odi-supporter-#{badge_image_size}.png"
    send_data Rails.application.assets[asset].to_s, filename: filename
  end

  private

  def badge_type
    @level == 'partner' ? 'partner' : 'supporter'
  end

  def badge_size
    @size == 'mini' ? 'mini' : 'standard'
  end

  def badge_image_size
    params[:size] if %w[16px 80px 100px 170px].include?(params[:size])
  end

  def badge_colour
    params[:colour] if %w[black grey orange].include?(params[:colour])
  end

end
