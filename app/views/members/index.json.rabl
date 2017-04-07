object false

node(:version) {"0.1"}
node(:profile) {"http://schema.theodi.org/membership"}

node(:memberships) do
  @listings.map do |listing|
    partial 'members/membership', object: listing, root: false
  end
end