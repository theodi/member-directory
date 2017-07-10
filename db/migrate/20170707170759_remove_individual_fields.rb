class RemoveIndividualFields < ActiveRecord::Migration
  def change
    remove_column :members, :university_email, :string
    remove_column :members, :university_street_address, :string
    remove_column :members, :university_address_locality, :string
    remove_column :members, :university_address_region, :string
    remove_column :members, :university_address_country, :string
    remove_column :members, :university_postal_code, :string
    remove_column :members, :university_country, :string
    remove_column :members, :university_name, :string
    remove_column :members, :university_name_other, :string
    remove_column :members, :university_course_name, :string
    remove_column :members, :university_qualification, :string
    remove_column :members, :university_qualification_other, :string
    remove_column :members, :university_course_start_date, :date
    remove_column :members, :university_course_end_date, :date
    remove_column :members, :dob, :date
    remove_column :members, :subscription_amount, :float, default: nil
  end
end
