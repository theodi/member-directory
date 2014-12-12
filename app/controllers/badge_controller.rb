class BadgeController < ApplicationController

  before_filter :set_formats, :only => [:logo]

  def logo
    render "logos/#{badge_type}-#{badge_size}", format: :svg
  end

  private

  def badge_type
    @level == 'partner' ? 'partner' : 'supporter'
  end

  def badge_size
    @size == 'mini' ? 'mini' : 'standard'
  end

end
