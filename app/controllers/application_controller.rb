class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_content_location_header

  before_filter :set_formats, :only => [:logo]

  def set_content_location_header
    if request.format
      extension = '.' + request.format.symbol.to_s
      path_with_extension = request.path.include?(extension) ? request.path : request.path+extension
      query_string = request.query_string.empty? ? '' : ('?'+request.query_string)
      response.headers["Content-Location"] = [request.protocol, request.host_with_port, path_with_extension, query_string].join
    end
  end

  def logo
    @colour = params[:colour]
    if ['standard', 'large'].include?(params[:size])
      @size == 'large' ? @size = 100 : @size = 80
      render "logos/#{params[:level]}-standard", format: :svg
    else
      render "logos/#{params[:level]}-mini", format: :svg
    end
  end

  private

  def after_sign_in_path_for(resource)
    resource.is_a?(Member) ? member_path(resource) : members_path
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer || root_path
  end

  def editable?(organization)
    (organization.member == current_member) || current_admin
  end
  helper_method :editable?

  def set_formats
    @size = params[:size] if ['standard', 'large', 'mini'].include?(params[:size])
    @align = params[:align] if ['left', 'right', 'top-left', 'top-right', 'bottom-left', 'bottom-right'].include?(params[:align])
    @colour = params[:colour] if ['black', 'blue', 'red', 'crimson', 'orange', 'green', 'pomegranate', 'grey'].include?(params[:colour])
  end

end
