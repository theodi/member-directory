object false

node(:version) {"0.1"}
node(:profile) {"http://schema.theodi.org/membership"}

node(:memberships) do
  @members.map do |member|
    partial 'members/membership', object: member, root: false
  end
end