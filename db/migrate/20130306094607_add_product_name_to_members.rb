class AddProductNameToMembers < ActiveRecord::Migration[3.2]
  def change
    add_column :members, :product_name, :string
  end
end
