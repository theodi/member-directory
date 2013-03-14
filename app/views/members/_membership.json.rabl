node(:url         ) { |org| member_url(org.member) }
node(:membershipId) { |org| org.member.membership_number }
node(:role        ) do |org|
  {
    :url  => "http://schema.theodi.org/membership/#{org.member.product_name}",
    :name => org.member.product_name,
  }
end
node :member do |org|
  member = {
    :type         => "http://schema.org/Organization",
    :name         => org.name,
    :description  => org.description,
    :url          => org.url
  }
  if root_object.logo.url
    member[:logo] = [
      {
        :type        => "http://schema.org/ImageObject",
        :description => "Original",
        :contentUrl  => org.logo.url,
        :thumbnail   => {
          :type        => "http://schema.org/ImageObject",
          :contentUrl  => "TODO",
        }
      }
    ]
  end
  member
end