class UploadsController < ApplicationController

  before_filter :authenticate_admin!

  def new
  end

  def create
  end
  
  def sample
    respond_to do |wants|
      wants.csv do
        csv = CSV.generate do |csv|
          sample_data = {
            "name" => "Bob Fish",
            "email" => "bob@example.edu",
            "dob_day" => "01",
            "dob_month" => "02",
            "dob_year" => "1990",
            "address_street" => "29 Acacia Road",
            "address_locality" => "",
            "address_town" => "London",
            "address_country" => "GB",
            "address_postcode" => "SW1A 1AA",
            "university_name" => "University of Life",
            "qualification" => "BSc",
            "course_name" => "Quantum Morphogenetics",
            "course_start_month" => "09",
            "course_start_year" => "2013",
            "course_end_month" => "06",
            "course_end_year" => "2016",
          }
          csv << sample_data.keys
          csv << sample_data.values
        end
        send_data csv
      end
    end
  end
  
end
