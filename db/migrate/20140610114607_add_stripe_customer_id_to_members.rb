class AddStripeCustomerIdToMembers < ActiveRecord::Migration[3.2]
  def change
    add_column :members, :stripe_customer_id, :string
  end
end
