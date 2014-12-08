class RegistrationsController < Devise::RegistrationsController
  before_filter :check_product_name, :only => 'new'
  before_filter :set_title, :only => %w[new create]
  helper_method :individual?

  def new
    if %w{partner sponsor}.include? @product_name
      @contact_request = ContactRequest.new
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

  protected

  def check_product_name
    @product_name = params[:level].to_s
    redirect_to 'http://www.theodi.org/join-us' unless Member.is_current_supporter_level?(@product_name)
  end

  def set_title
    @title = case @product_name
    when 'sponsor'
      'Sponsor us'
    when 'partner'
      'Partner with us'
    else
      "Sign up"
    end
  end

  def individual?
    @member.individual? || Member.is_individual_level?(@product_name)
  end

end
