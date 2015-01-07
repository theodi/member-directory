class AddDetailsForIndividual < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.string :name
      t.string :phone
      t.text :address
    end
  end
end
