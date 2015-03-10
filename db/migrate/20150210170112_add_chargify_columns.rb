class AddChargifyColumns < ActiveRecord::Migration
  def up
    add_column :members, :chargify_customer_id, :string
    add_column :members, :chargify_subscription_id, :string
    add_column :members, :chargify_payment_id, :string
    add_column :members, :chargify_data_verified, :boolean, default: false, null: true
  end

  def down
    remove_column :members, :chargify_customer_id
    remove_column :members, :chargify_subscription_id
    remove_column :members, :chargify_payment_id
    remove_column :members, :chargify_data_verified
  end
end
