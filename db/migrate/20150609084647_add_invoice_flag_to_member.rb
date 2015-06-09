class AddInvoiceFlagToMember < ActiveRecord::Migration
  def change
    add_column :members, :invoice, :boolean, default: false
  end
end
