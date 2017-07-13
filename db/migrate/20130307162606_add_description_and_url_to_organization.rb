class AddDescriptionAndUrlToOrganization < ActiveRecord::Migration[3.2]
  def change
    add_column :organizations, :description, :text
    add_column :organizations, :url, :string
  end
end
