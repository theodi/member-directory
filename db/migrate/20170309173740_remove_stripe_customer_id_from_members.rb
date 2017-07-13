class RemoveStripeCustomerIdFromMembers < ActiveRecord::Migration[3.2]
  def change
    remove_column :members, :stripe_customer_id, :string
  end
end
