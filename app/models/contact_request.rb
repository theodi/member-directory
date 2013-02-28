class ContactRequest
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :person_name, :person_affiliation, :person_email, :person_telephone, :person_job_title, :product_name, :comment_text

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
  def save
    Resque.enqueue(PartnerEnquiryProcessor, {
        'name'        => person_name,
        'affiliation' => person_affiliation,
        'email'       => person_email,
        'telephone'   => person_telephone,
        'job_title'   => person_job_title
      },
      { 'name' => product_name },
      { 'text' => comment_text }
    )
  end
  
end
