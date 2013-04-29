class ErrorsController < ApplicationController

  def unauthorized
    render :status => 401, :formats => [:html]
  end

  def not_found
    render :status => 404, :formats => [:html]
  end

  def server_error
    render :status => 500, :formats => [:html]
  end

end