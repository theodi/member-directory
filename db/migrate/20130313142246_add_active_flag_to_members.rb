class AddActiveFlagToMembers < ActiveRecord::Migration[3.2]
  def self.up
    add_column :members, :cached_active, :boolean, :default => false
  end

  def self.down
    remove_column :members, :cached_active
  end
end
