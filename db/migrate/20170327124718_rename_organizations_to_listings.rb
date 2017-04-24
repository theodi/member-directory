class RenameOrganizationsToListings < ActiveRecord::Migration
  def change
    rename_table :organizations, :listings
  end
end
