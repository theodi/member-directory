class AddTwitterAndDobFields < ActiveRecord::Migration
  def change
    add_column :members, :twitter, :string
    add_column :members, :dob, :date
  end
end
