class RemoveFinancialFields < ActiveRecord::Migration
  def change
    remove_column :members, :chargify_customer_id, :string
    remove_column :members, :chargify_subscription_id, :string
    remove_column :members, :chargify_payment_id, :string
    remove_column :members, :chargify_data_verified, :boolean, default: false, null: true
    remove_column :members, :coupon, :string
    remove_column :members, :payment_frequency, :string, default: 'annual', null: false
    remove_column :members, :invoice, :boolean, default: false
    remove_column :members, :organization_vat_id, :string
  end
end
