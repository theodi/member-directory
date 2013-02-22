class AddMembershipNumberToMembers < ActiveRecord::Migration
  def change
    add_column :members, :membership_number, :integer, :limit => 8
  end
end
