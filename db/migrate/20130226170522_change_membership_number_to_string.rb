class ChangeMembershipNumberToString < ActiveRecord::Migration[3.2]
  def up
    change_column :members, :membership_number, :string
  end

  def down
    change_column :members, :membership_number, :integer
  end
end
