class AddMembershipNumberToMembers < ActiveRecord::Migration[3.2]
  def change
    add_column :members, :membership_number, :integer, :limit => 8
  end
end
