class RemoveFinancialFields < ActiveRecord::Migration[3.2]
  def change
    remove_column :members, :chargify_customer_id
    remove_column :members, :chargify_subscription_id
    remove_column :members, :chargify_payment_id
    remove_column :members, :chargify_data_verified
    remove_column :members, :coupon
    remove_column :members, :payment_frequency
    remove_column :members, :invoice
    remove_column :members, :organization_vat_id
  end
end
