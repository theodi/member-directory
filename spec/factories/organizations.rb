# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name        { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    url         { Faker::Internet.url }
    member
  end
end
