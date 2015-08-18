class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_content_location_header

  def set_content_location_header
    if request.format
      extension = '.' + request.format.symbol.to_s
      path_with_extension = request.path.include?(extension) ? request.path : request.path+extension
      query_string = request.query_string.empty? ? '' : ('?'+request.query_string)
      response.headers["Content-Location"] = [request.protocol, request.host_with_port, path_with_extension, query_string].join
    end
  end

  private

  def set_formats
    @size = params[:size] if ['mini', 'small', 'medium', 'large'].include?(params[:size])
    @align = params[:align] if ['left', 'right', 'top-left', 'top-right', 'bottom-left', 'bottom-right'].include?(params[:align])
    @colour = params[:colour] if ['black', 'blue', 'red', 'crimson', 'orange', 'green', 'pomegranate', 'grey'].include?(params[:colour])
    @level = params[:level] if %w[partner supporter].include?(params[:level])
  end

  def after_sign_in_path_for(resource)
    resource.is_a?(Member) ? member_path(resource) : members_path
  end

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :member && current_member && (current_member.individual? || !current_member.cached_active)
      root_path
    else
      request.referrer || root_path
    end
  end

  def editable?(member)
    (member == current_member) || current_admin
  end
  helper_method :editable?

end
