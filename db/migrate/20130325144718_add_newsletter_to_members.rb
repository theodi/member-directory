class AddNewsletterToMembers < ActiveRecord::Migration
  def change
    add_column :members, :cached_newsletter, :boolean, :default => false
  end
end
