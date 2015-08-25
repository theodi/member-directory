class CapsuleObserver

  def self.register
    SyncCapsuleData.add_observer(self)
  end

  # Receives data updates from CapsuleCRM
  #
  # membership      -  hash of membership data from CapsuleCRM
  #                 email         => The contact email for the membership
  #                 product_name  => The membership level
  #                 id            => The membership ID (if this is nil, it must be a new member)
  # directory_entry -  hash of directory data from CapsuleCRM
  #                 active        => Whether the membership is active or not (will be shown in the public directory)
  #                 name          => The organization name
  #                 description   => The organization description
  #                 url           => The organization's homepage
  #                 contact       => Name of sales contact
  #                 phone         => Phone number of sales contact
  #                 email         => Email of sales contact
  #                 twitter       => Twitter account
  #                 linkedin      => Linkedin URL
  #                 facebook      => Facebook URL
  #                 tagline       => Tagline
  # capsule_id      - the identifier of the organisation in CapsuleCRM
  #
  def self.update(membership, directory_entry, capsule_id)

    # Existing member
    if membership['id']

      member = Member.where(:membership_number => membership['id']).first
      if member
        member.cached_active       = (directory_entry['active'] == "true")
        member.product_name        = membership['product_name']
        member.cached_newsletter   = membership['newsletter']
        member.organization_size   = membership['size'] if membership['size']
        member.organization_sector = membership['sector'] if membership['sector']
        member.remote!
        member.save(:validate => false)

        if org = member.organization
          org.name                 = directory_entry['name']
          org.url                  = directory_entry['url']
          org.cached_contact_name  = directory_entry['contact']
          org.cached_contact_phone = directory_entry['phone']
          org.cached_contact_email = directory_entry['email']
          org.cached_twitter       = directory_entry['twitter']
          org.cached_linkedin      = directory_entry['linkedin']
          org.cached_facebook      = directory_entry['facebook']
          org.cached_tagline       = directory_entry['tagline']
          org.save(:validate => false)
        end
      end

    # ..if not, create a new member with the synced data
    else
      member = Member.new(
        :email             => membership['email'],
        :organization_name => directory_entry['name'],
        :product_name      => membership['product_name']
      )
      member.remote!

      if member.organization?
        member.cached_active = true
      end

      member.current = true
      member.send :generate_reset_password_token

      begin
        member.save(:validate => false)
        DeviseMailer.send(:new).confirmation_instructions(member, {capsule: true}).deliver
      rescue ActiveRecord::StatementInvalid
        ErrorMailer.membership_number_generation_failed(capsule_id).deliver
      end
    end
  end
end

CapsuleObserver.register

