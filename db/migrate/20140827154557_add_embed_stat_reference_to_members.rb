class AddEmbedStatReferenceToMembers < ActiveRecord::Migration
  def change
    add_column :members, :embed_stat_id, :integer
  end
end
