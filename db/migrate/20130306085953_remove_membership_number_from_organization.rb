class RemoveMembershipNumberFromOrganization < ActiveRecord::Migration
  def up
    remove_column :organizations, :membership_number
  end

  def down
    add_column :organizations, :membership_number, :string
  end
end
