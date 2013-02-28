class ContactRequestsController < ApplicationController
  # GET /contact_requests/new
  # GET /contact_requests/new.json
  def new
    @contact_request = ContactRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact_request }
    end
  end

  # POST /contact_requests
  # POST /contact_requests.json
  def create
    @contact_request = ContactRequest.new(params[:contact_request])

    respond_to do |format|
      if @contact_request.save
        format.html { redirect_to @contact_request, notice: 'Contact request was successfully created.' }
        format.json { render json: @contact_request, status: :created, location: @contact_request }
      else
        format.html { render action: "new" }
        format.json { render json: @contact_request.errors, status: :unprocessable_entity }
      end
    end
  end

end
