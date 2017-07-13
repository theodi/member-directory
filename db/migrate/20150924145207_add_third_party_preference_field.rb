class AddThirdPartyPreferenceField < ActiveRecord::Migration[3.2]
  def change
    add_column :members, :cached_share_with_third_parties, :boolean, :default => false
  end
end
