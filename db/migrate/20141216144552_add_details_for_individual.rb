class AddDetailsForIndividual < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.string :name
      t.string :phone
    end
  end
end
