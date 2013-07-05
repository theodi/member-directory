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

  def after_sign_in_path_for(resource)
    resource.is_a?(Member) ? member_path(resource) : members_path
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer || root_path
  end

  def editable?(organization)
    (organization.member == current_member)# || current_admin
  end
  helper_method :editable?

end
