class AddSubscriptionAmountToMember < ActiveRecord::Migration
  def change
    add_column :members, :subscription_amount, :float, default: nil
  end
end
