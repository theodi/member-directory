class AddMemberAddressFragments < ActiveRecord::Migration
  def up
    add_column :members, :street_address, :string
    add_column :members, :address_locality, :string
    add_column :members, :address_region, :string
    add_column :members, :address_country, :string
    add_column :members, :postal_code, :string
    add_column :members, :organization_type, :string
    add_column :members, :organization_vat_id, :string
    add_column :members, :organization_company_number, :string
  end

  def down
    remove_column :members, :street_address
    remove_column :members, :address_locality
    remove_column :members, :address_region
    remove_column :members, :address_country
    remove_column :members, :postal_code
    remove_column :members, :organization_type
    remove_column :members, :organization_vat_id
    remove_column :members, :organization_company_number
  end
end
