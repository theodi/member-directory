class CreateEmbedStats < ActiveRecord::Migration
  def change
    create_table(:embed_stats) do |t|
      t.string     :referrer
      t.belongs_to :member

      t.timestamps
    end

    add_index :embed_stats, :referrer, :unique => true
  end
end
