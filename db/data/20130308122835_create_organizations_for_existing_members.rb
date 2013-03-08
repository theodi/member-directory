class CreateOrganizationsForExistingMembers < ActiveRecord::Migration
  def self.up
    Member.includes(:organization).where('organizations.id IS NULL').each do |m|
      # Use send as setup_organization is private
      m.send(:setup_organization)
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
