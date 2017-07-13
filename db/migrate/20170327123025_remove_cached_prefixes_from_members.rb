class RemoveCachedPrefixesFromMembers < ActiveRecord::Migration[3.2]
  def change
    rename_column :members, :cached_active, :active
    rename_column :members, :cached_newsletter, :newsletter
    rename_column :members, :cached_share_with_third_parties, :share_with_third_parties
  end
end
