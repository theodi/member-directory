class UpdateDirectoryEntry
  extend Forwardable

  def_delegators :directory_entry_update,
    :membership_number,
    :organization_name,
    :directory_entry,
    :update_date

  attr_reader :organization

  def self.update!(organization)
    new(organization).update!
  end

  def initialize(organization)
    @organization = organization
  end

  def update!
    Resque.enqueue(SendDirectoryEntryToCapsule,
      membership_number,
      organization_name,
      directory_entry,
      update_date
    )
  end

  def directory_entry_update
    @directory_entry_update ||= DirectoryEntryUpdate.new(organization)
  end
end

