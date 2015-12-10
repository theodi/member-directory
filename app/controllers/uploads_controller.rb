class UploadsController < ApplicationController

  before_filter :authenticate_admin!

  def new
  end

  def create
    @members = []
    csv = CSV.parse(params[:file].read, headers: true)
    csv.each do |row|
      @members << create_student_member_from_row(row)
    end
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
            "university_name" => University.names.first,
            "qualification" => Qualification.names.first,
            "course_name" => "Quantum Morphogenetics",
            "course_start_month" => "09",
            "course_start_year" => "2013",
            "course_end_month" => "06",
            "course_end_year" => "2016",
            "coupon_code" => "SUPERFREE"
          }
          csv << sample_data.keys
          csv << sample_data.values
        end
        send_data csv
      end
    end
  end
  
  private
  
  def create_student_member_from_row(row)
    Member.create_without_password!(
      contact_name: row["name"],
      email: row["email"],
      university_email: row["email"],
      dob_day: row['dob_day'],
      dob_month: row['dob_month'],
      dob_year: row['dob_year'],
      product_name: "student",
      invoice: false,
      cached_newsletter: true,
      street_address: row["address_street"],
      address_locality: row["address_locality"],
      address_region: row["address_town"],
      address_country: row["address_country"],
      postal_code: row["address_postcode"],
      university_address_country: row["address_country"],
      university_country: row["address_country"],
      university_name: University.select_name(row["university_name"]),
      university_name_other: University.select_name_other(row["university_name"]),
      university_qualification: Qualification.select_name(row["qualification"]),
      university_qualification_other: Qualification.select_name_other(row["qualification"]),
      university_course_name: row["course_name"],
      university_course_start_date_year: row["course_start_year"],
      university_course_start_date_month: row["course_start_month"],
      university_course_end_date_year: row["course_end_year"],
      university_course_end_date_month: row["course_end_month"],
    )
  end
  
end
