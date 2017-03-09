class RemoveStripeCustomerIdFromMembers < ActiveRecord::Migration
  def change
    remove_column :members, :stripe_customer_id, :string
  end
end
