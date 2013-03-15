# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member do
    email             { Faker::Internet.email }
    product_name      'member'
    organization_name { Faker::Company.name }
    contact_name      { Faker::Name.name }
    street_address    { Faker::Address.street_address }
    address_locality  { Faker::Address.city }
    address_country   { Faker::Address.country }
    postal_code       { Faker::Address.postcode }
    password          'passw0rd'
  end
end
