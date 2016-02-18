class RemoveUniversityAddressFields < ActiveRecord::Migration
  def change
    remove_column :members, :university_street_address
    remove_column :members, :university_address_locality
    remove_column :members, :university_address_region
    remove_column :members, :university_postal_code
  end
end
