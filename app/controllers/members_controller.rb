class MembersController < ApplicationController

  def index
    @organizations = Organization.all
  end

  def show
    @organization = Member.find(params[:id]).organization
  end
  
end
