object false

node(:version) {"0.1"}
node(:profile) {"http://schema.theodi.org/membership"}

child @member => 'membership' do
  extends "members/membership"
end