class RegistrationsController < Devise::RegistrationsController
  before_filter :check_product_name, :only => 'new'

  def new
    if %w{partner sponsor}.include? @product_name
      @contact_request = ContactRequest.new
      @product_name == "sponsor" ? @title = "Sponsor us" : @title = "Partner with us"
      render 'contact_requests/new'
    else
      super
    end
  end

  def create
    if params[:contact_request] 
      @contact_request = ContactRequest.new(params[:contact_request])
      @product_name = @contact_request.product_name    
      respond_to do |format|
        if @contact_request.save
          format.html { render "contact_requests/create" }
          format.json { render json: @contact_request, status: :created, location: @contact_request }
        else
          format.html { render "contact_requests/new" }
          format.json { render json: @contact_request.errors, status: :unprocessable_entity }
        end
      end
    else
      super
    end
  end

  def edit
    @preview = true
    super
  end
  
  def update
    # Prepend http to URL if not present
    if params[:member].try(:[], :organization_attributes).try(:[], :url)
      unless params[:member][:organization_attributes][:url] =~ /^([a-z]+):\/\//
        params[:member][:organization_attributes][:url] = "http://#{params[:member][:organization_attributes][:url]}"
      end
    end
    # Call base update
    super
  end  
  
  protected

  def check_product_name
    @product_name = params[:level].to_s
    redirect_to 'http://www.theodi.org/join-us' unless %w{supporter member partner sponsor}.include?(@product_name)
  end

end