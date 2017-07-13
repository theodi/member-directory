class RenameOrganizationsToListings < ActiveRecord::Migration[3.2]
  def change
    rename_table :organizations, :listings
  end
end
