class HomeController < ApplicationController

  def index
  end

  def terms
    @title = "Terms & conditions"
    @terms = case params[:product]
    when 'individual'
      'individual_terms'
    when 'supporter'
      'terms'
    else
      raise ActiveRecord::RecordNotFound
    end
  end

end
