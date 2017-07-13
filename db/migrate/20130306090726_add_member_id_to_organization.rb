class AddMemberIdToOrganization < ActiveRecord::Migration[3.2]
  def change
    add_column :organizations, :member_id, :integer
  end
end
