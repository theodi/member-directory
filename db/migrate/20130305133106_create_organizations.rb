class CreateOrganizations < ActiveRecord::Migration[3.2]
  def change
    create_table :organizations do |t|
      t.string  :name
      t.string  :membership_number 

      t.timestamps
    end
  end
end
