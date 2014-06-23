class AddStripeCustomerIdToMembers < ActiveRecord::Migration
  def change
    add_column :members, :stripe_customer_id, :string
  end
end
