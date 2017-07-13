class TrackCurrentMembers < ActiveRecord::Migration[3.2]
  def up
    add_column :members, :current, :boolean, default: false, null: false
    update("update members set current = 1")
  end

  def down
    remove_column :members, :current
  end
end
