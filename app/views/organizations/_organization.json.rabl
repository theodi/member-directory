attributes :name, :description, :url

node(:'@type') { "http://schema.org/Organization" }
node(:'@id'  ) { |org| member_url(org.member) }

node :membership do |org|
  {
    :type         => "http://schema.org/Product",
    :name         => org.member.product_name,
    :membershipId => org.member.membership_number,
  }
end

if root_object.logo.url
  node :logo do |org|
    [
      {
        :'@type'     => "http://schema.org/ImageObject",
        :description => "Full-sized logo image",
        :contentUrl  => org.logo.url,
        :thumbnail   => {
          :'@type'     => "http://schema.org/ImageObject",
          :contentUrl  => "TODO",
        }
      }
    ]
  end
end