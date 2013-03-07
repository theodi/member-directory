class AddDescriptionAndUrlToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :description, :text
    add_column :organizations, :url, :string
  end
end
