class DirectoryEntryUpdate
  extend Forwardable

  attr_reader :organization

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

  def update_date
    updated_at.to_s
  end

  def membership_number
    member.membership_number
  end

  def organization_name
    {
      :name => name
    }
  end

  def directory_entry
    {
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
      :tagline     => cached_tagline
    }
  end

  def logo_url
    logo.url
  end

  def square_url
    logo.square.url
  end
end

