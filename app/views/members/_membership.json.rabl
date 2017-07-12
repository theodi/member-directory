node(:url         ) { |member| member_url(member) }
node(:membershipId) { |member| member.membership_number }
if root_object.product_name
  node(:role        ) do |member|
    {
      :url  => "http://schema.theodi.org/membership/#{member.product_name}",
      :name => member.product_name.capitalize,
    }
  end
end
node :member do |member|
  # Basics
  details = {
    :type         => "http://schema.org/Organization",
    :name         => member.organization_name,
    :description  => member.organization_description,
    :url          => member.organization_url
  }
  # Contact point
  details[:contactPoint] = [
    {
      :description  => "Sales contact",
      :type         => "http://schema.org/ContactPoint",
      :name         => member.organization_contact_name,
      :email        => member.organization_contact_email,
      :telephone    => member.organization_contact_phone
    },
  ]
  # Social media URLs
  if member.organization_twitter.present?
    details[:contactPoint] << {
      :name         => "Twitter",
      :type         => "http://schema.org/ContactPoint",
      :url          => member.twitter_url
    }
  end
  if member.organization_facebook.present?
    details[:contactPoint] << {
      :name         => "Facebook",
      :type         => "http://schema.org/ContactPoint",
      :url          => member.organization_facebook
    }
  end
  if member.organization_linkedin.present?
    details[:contactPoint] << {
      :name         => "Linkedin",
      :type         => "http://schema.org/ContactPoint",
      :url          => member.organization_linkedin
    }
  end
  # Logo
  if root_object.organization_logo.url
    details[:logo] = [
      {
        :type        => "http://schema.org/ImageObject",
        :description => "Original",
        :contentUrl  => member.organization_logo.url,
        :thumbnail   => {
          :type        => "http://schema.org/ImageObject",
          :contentUrl  => member.organization_logo.square.url,
          :height      => 100,
          :width       => 100,
        }
      },
      {
        :type        => "http://schema.org/ImageObject",
        :description => "Rectangular",
        :contentUrl  => member.organization_logo.rectangular.url,
        :height      => 100,
        :width       => 200,
        :thumbnail   => {
          :type        => "http://schema.org/ImageObject",
          :contentUrl  => member.organization_logo.square.url,
          :height      => 100,
          :width       => 100,
        }
      }
    ]
  end
  details
end