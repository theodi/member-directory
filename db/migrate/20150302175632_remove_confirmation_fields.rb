class RemoveConfirmationFields < ActiveRecord::Migration[3.2]
  def up
    remove_column :members, :confirmation_token
    remove_column :members, :confirmed_at
    remove_column :members, :confirmation_sent_at
    remove_column :members, :unconfirmed_email
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
