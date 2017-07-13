class AddEmbedStatReferenceToMembers < ActiveRecord::Migration[3.2]
  def change
    add_column :members, :embed_stat_id, :integer
  end
end
