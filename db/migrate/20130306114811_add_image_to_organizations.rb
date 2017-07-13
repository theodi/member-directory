class AddImageToOrganizations < ActiveRecord::Migration[3.2]
  def change
    add_column :organizations, :logo, :string
  end
end
