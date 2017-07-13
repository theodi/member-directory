class AddSectorAndSizeToMembers < ActiveRecord::Migration[3.2]
  def change
    add_column :members, :organization_sector, :string
    add_column :members, :organization_size, :string
  end
end
