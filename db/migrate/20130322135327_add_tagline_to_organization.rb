class AddTaglineToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :cached_tagline, :string
  end
end
