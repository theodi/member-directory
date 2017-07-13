class AddSubscriptionAmountToMember < ActiveRecord::Migration[3.2]
  def change
    add_column :members, :subscription_amount, :float, default: nil
  end
end
