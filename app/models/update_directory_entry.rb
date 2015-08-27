class UpdateDirectoryEntry
  extend Forwardable

  attr_reader :organization

  def self.update!(organization)
    new(organization).update!
  end

  def initialize(organization)
    @organization = organization
  end

  def_delegators :organization,
    :name,
    :description,
    :url,
    :logo,
    :cached_contact_name,
    :cached_contact_phone,
    :cached_contact_email,
    :cached_twitter,
    :cached_linkedin,
    :cached_facebook,
    :cached_tagline,
    :updated_at,
    :member

  def logo_url
    logo.url
  end

  def square_url
    logo.square.url
  end

  def update!
    if organization.valid? && organization.changed?
      organization = {
        :name => name
      }

      directory_entry = {
        :description => description,
        :homepage    => url,
        :logo        => logo_url,
        :thumbnail   => square_url,
        :contact     => cached_contact_name,
        :phone       => cached_contact_phone,
        :email       => cached_contact_email,
        :twitter     => cached_twitter,
        :linkedin    => cached_linkedin,
        :facebook    => cached_facebook,
        :tagline     => cached_tagline,
      }

      date = updated_at.to_s

      Resque.enqueue(SendDirectoryEntryToCapsule, member.membership_number, organization, directory_entry, date)
    end
  end
end

