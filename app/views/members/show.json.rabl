object false

node(:version) {"0.1"}
node(:profile) {"http://schema.theodi.org/membership"}

child @listing => 'membership' do
  extends "members/membership"
end