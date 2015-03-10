class TrackCurrentMembers < ActiveRecord::Migration
  def up
    add_column :members, :current, :boolean, default: false, null: false
    update("update members set current = true")
  end

  def down
    remove_column :members, :current
  end
end
