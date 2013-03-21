node(:url         ) { |org| member_url(org.member) }
node(:membershipId) { |org| org.member.membership_number }
if root_object.member.product_name
  node(:role        ) do |org|
    {
      :url  => "http://schema.theodi.org/membership/#{org.member.product_name}",
      :name => org.member.product_name.capitalize,
    }
  end
end
node :member do |org|
  # Basics
  member = {
    :type         => "http://schema.org/Organization",
    :name         => org.name,
    :description  => org.description,
    :url          => [
      org.url,
      org.cached_facebook,
      org.cached_linkedin,
      org.twitter_url
    ].compact
  }
  # Contact point
  member[:contactPoint] = {
    :type         => "http://schema.org/ContactPoint",
    :name         => org.cached_contact_name,
    :email        => org.cached_contact_email,
    :telephone    => org.cached_contact_phone
  }.compact
  # Logo
  if root_object.logo.url
    member[:logo] = [
      {
        :type        => "http://schema.org/ImageObject",
        :description => "Original",
        :contentUrl  => org.logo.url,
        :thumbnail   => {
          :type        => "http://schema.org/ImageObject",
          :contentUrl  => org.logo.square.url,
          :height      => 100,
          :width       => 100,
        }
      },
      {
        :type        => "http://schema.org/ImageObject",
        :description => "Rectangular",
        :contentUrl  => org.logo.rectangular.url,
        :height      => 100,
        :width       => 200,
        :thumbnail   => {
          :type        => "http://schema.org/ImageObject",
          :contentUrl  => org.logo.square.url,
          :height      => 100,
          :width       => 100,
        }
      }
    ]
  end
  member
end