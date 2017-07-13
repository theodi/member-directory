class CreateEmbedStats < ActiveRecord::Migration[3.2]
  def change
    create_table(:embed_stats) do |t|
      t.string     :referrer
      t.belongs_to :member

      t.timestamps
    end

    add_index :embed_stats, :referrer, :unique => true
  end
end
