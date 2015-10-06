class AddExtraStudentFields < ActiveRecord::Migration
  def change
    add_column :members, :university_email, :string
    add_column :members, :university_street_address, :string
    add_column :members, :university_address_locality, :string
    add_column :members, :university_address_region, :string
    add_column :members, :university_address_country, :string
    add_column :members, :university_postal_code, :string
    add_column :members, :university_country, :string
    add_column :members, :university_name, :string
    add_column :members, :university_name_other, :string
    add_column :members, :university_course_name, :string
    add_column :members, :university_qualification, :string
    add_column :members, :university_qualification_other, :string
    add_column :members, :university_course_start_date, :date
    add_column :members, :university_course_end_date, :date
  end
end
