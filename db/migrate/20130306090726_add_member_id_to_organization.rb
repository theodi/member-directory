class AddMemberIdToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :member_id, :integer
  end
end
