class AddChargifyColumns < ActiveRecord::Migration
  def up
    add_column :members, :chargify_customer_id, :string
    add_column :members, :chargify_subscription_id, :string
    add_column :members, :chargify_product_id, :string
    add_column :members, :chargify_payment_id, :string
    add_column :members, :chargify_data_verified, :boolean, default: false, null: false
  end

  def down
    remove_column :members, :chargify_customer_id
    remove_column :members, :chargify_subscription_id
    remove_column :members, :chargify_product_id
    remove_column :members, :chargify_payment_id
  end
end
