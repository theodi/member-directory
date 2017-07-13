class AddTaglineToOrganization < ActiveRecord::Migration[3.2]
  def change
    add_column :organizations, :cached_tagline, :string
  end
end
