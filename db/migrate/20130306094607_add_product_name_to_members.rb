class AddProductNameToMembers < ActiveRecord::Migration
  def change
    add_column :members, :product_name, :string
  end
end
