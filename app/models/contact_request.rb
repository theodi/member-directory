class ContactRequest
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Translation
  extend ActiveModel::Naming
  
  attr_accessor :person_name, :person_affiliation, :person_email, :person_telephone, :person_job_title, :product_name, :comment_text, :honeypot

  validates :person_name       , :presence => true
  validates :person_affiliation, :presence => true
  validates :person_email      , :presence => true
  validates :person_telephone  , :presence => true
  validates :person_job_title  , :presence => true
  validates :product_name      , :presence => true, :inclusion => %w{supporter member partner sponsor}
  validates :comment_text      , :presence => true
  validates :honeypot          , :presence => true, :inclusion => { in: ["0"], message: "must not be ticked" }

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
  def save
    # Validations
    return false unless valid?
    # Queue
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
    true
  end
  
end
