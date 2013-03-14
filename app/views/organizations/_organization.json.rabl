node(:'@id') { |org| member_url(org.member) }
node(:'@type') {"http://schema.org/Organization"}
attributes :name, :description, :url
node(:logo) {|org| org.logo.to_s }
node(:membershipId) { |org| org.member.membership_number }