class AddInvoiceFlagToMember < ActiveRecord::Migration[3.2]
  def change
    add_column :members, :invoice, :boolean, default: false
  end
end
