class ContactRequestsController < ApplicationController
  before_filter :check_product_name, :only => 'new'

  # GET /contact_requests/new
  # GET /contact_requests/new.json
  def new
    @contact_request = ContactRequest.new
    @product_name = params[:level]
    @product_name == "sponsor" ? @title = "Sponsor us" : @title = "Partner with us"
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact_request }
    end
  end

  # POST /contact_requests
  # POST /contact_requests.json
  def create
    @contact_request = ContactRequest.new(params[:contact_request])
    @product_name = @contact_request.product_name    
    respond_to do |format|
      if @contact_request.save
        format.html { render }
        format.json { render json: @contact_request, status: :created, location: @contact_request }
      else
        format.html { render action: "new" }
        format.json { render json: @contact_request.errors, status: :unprocessable_entity }
      end
    end
  end

  protected
  
  def check_product_name
    redirect_to 'http://www.theodi.org/join-us' unless %w{partner sponsor}.include?(params[:level].to_s)
  end

end
