class AddContactFieldsToOrganization < ActiveRecord::Migration[3.2]
  def change
    add_column :organizations, :cached_contact_name, :string
    add_column :organizations, :cached_contact_phone, :string
    add_column :organizations, :cached_contact_email, :string
    add_column :organizations, :cached_twitter, :string
    add_column :organizations, :cached_facebook, :string
    add_column :organizations, :cached_linkedin, :string
  end
end
