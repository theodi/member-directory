class MergeListingsAndMembers < ActiveRecord::Migration[3.2]
  def up
    add_column :members, :organization_name, :string
    add_column :members, :organization_logo, :string
    add_column :members, :organization_description, :text
    add_column :members, :organization_url, :string
    add_column :members, :organization_contact_name, :string
    add_column :members, :organization_contact_phone, :string
    add_column :members, :organization_contact_email, :string
    add_column :members, :organization_twitter, :string
    add_column :members, :organization_facebook, :string
    add_column :members, :organization_linkedin, :string
    add_column :members, :organization_tagline, :string
  end

  def down
    remove_column :members, :organization_name
    remove_column :members, :organization_logo
    remove_column :members, :organization_description
    remove_column :members, :organization_url
    remove_column :members, :organization_contact_name
    remove_column :members, :organization_contact_phone
    remove_column :members, :organization_contact_email
    remove_column :members, :organization_twitter
    remove_column :members, :organization_facebook
    remove_column :members, :organization_linkedin
    remove_column :members, :organization_tagline
  end
end
