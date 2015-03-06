class AddPaymentFrequencyField < ActiveRecord::Migration
  def up
    add_column :members, :payment_frequency, :string, default: 'annual', null: false
  end

  def down
    remove_column :members, :payment_frequency
  end
end
