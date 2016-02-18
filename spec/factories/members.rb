# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member do
    email               { Faker::Internet.email }
    product_name        'supporter'
    organization_name   { Faker::Company.name }
    organization_type   'commercial'
    organization_size   '>1000'
    organization_sector "Data/Technology"
    contact_name        { Faker::Name.name }
    street_address      { Faker::Address.street_address }
    address_region      { Faker::Address.city }
    address_country     { Faker::Address.country }
    postal_code         { Faker::Address.postcode }
    password            'passw0rd'
  end

  factory :current_member, parent: :member do
    current true
  end

  factory :current_active_member, parent: :current_member do
    cached_active true
  end

  factory :individual_member, class: Member do
    email               { Faker::Internet.email }
    product_name        'individual'
    contact_name        { Faker::Name.name }
    street_address      { Faker::Address.street_address }
    address_region      { Faker::Address.city }
    address_country     { Faker::Address.country }
    postal_code         { Faker::Address.postcode }
    password            'passw0rd'
    subscription_amount 5
  end

  factory :current_individual_member, parent: :individual_member do
    current true
  end

  factory :current_active_individual_member, parent: :current_individual_member do
    cached_active true
  end
end
