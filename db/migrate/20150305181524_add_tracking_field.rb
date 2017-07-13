class AddTrackingField < ActiveRecord::Migration[3.2]
  def up
    add_column :members, :origin, :string, default: 'odihq', null: false
  end

  def down
    remove_column :members, :origin
  end
end
