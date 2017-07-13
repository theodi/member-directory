class AddNewsletterToMembers < ActiveRecord::Migration[3.2]
  def change
    add_column :members, :cached_newsletter, :boolean, :default => false
  end
end
