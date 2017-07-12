namespace :merge do
  task :listings => :environment do
    Listing.all.each do |listing|
      member = listing.member      
      if member
        member.organization_name = listing.name
        member.organization_logo = listing.logo
        member.organization_description = listing.description
        member.organization_url = listing.url
        member.organization_contact_name = listing.contact_name
        member.organization_contact_phone = listing.contact_phone
        member.organization_contact_email = listing.contact_email
        member.organization_twitter = listing.twitter
        member.organization_facebook = listing.facebook
        member.organization_linkedin = listing.linkedin
        member.organization_tagline = listing.tagline
        member.save!
      end      
    end    
  end
end