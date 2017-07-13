class RemoveIndividualFields < ActiveRecord::Migration[3.2]
  def change
    remove_column :members, :university_email
    remove_column :members, :university_street_address
    remove_column :members, :university_address_locality
    remove_column :members, :university_address_region
    remove_column :members, :university_address_country
    remove_column :members, :university_postal_code
    remove_column :members, :university_country
    remove_column :members, :university_name
    remove_column :members, :university_name_other
    remove_column :members, :university_course_name
    remove_column :members, :university_qualification
    remove_column :members, :university_qualification_other
    remove_column :members, :university_course_start_date
    remove_column :members, :university_course_end_date
    remove_column :members, :dob
    remove_column :members, :subscription_amount
  end
end
