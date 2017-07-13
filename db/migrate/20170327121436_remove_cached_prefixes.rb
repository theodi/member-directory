class RemoveCachedPrefixes < ActiveRecord::Migration[3.2]
  def change
    rename_column :organizations, :cached_contact_name, :contact_name
    rename_column :organizations, :cached_contact_phone, :contact_phone
    rename_column :organizations, :cached_contact_email, :contact_email
    rename_column :organizations, :cached_twitter, :twitter
    rename_column :organizations, :cached_facebook, :facebook
    rename_column :organizations, :cached_linkedin, :linkedin
    rename_column :organizations, :cached_tagline, :tagline
  end
end
