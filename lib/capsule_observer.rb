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
  #
  def self.update(membership, directory_entry)
    # Is there a membership ID?
    if membership['id']
      # If so, update the data in the appropriate member
      member = Member.where(:membership_number => membership['id']).first
      if member
        # Member data
        member.cached_active     = (directory_entry['active'] == "true")
        member.product_name      = membership['product_name']
        member.cached_newsletter = membership['newsletter']
        member.remote            = true
        # We don't store email here, that's only for new accounts
        member.save(:validate => false)
        # Update organization data
        if org = member.organization
          org.name                 = directory_entry['name']
          org.description          = directory_entry['description']
          org.url                  = directory_entry['url']
          org.remote               = true
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
    else
      # If not, create a new member with the synced data
      member = Member.new(
        :email             => membership['email'],
        :organization_name => directory_entry['name'],
        :product_name      => membership['product_name'],
        :remote            => true # Disable callbacks
      )
      member.cached_active = false # We always set this false on create so that
                                   # incomplete entries don't go immediately live
      # Save without validation
      member.save(:validate => false)
    end
  end
  
end

CapsuleObserver.register