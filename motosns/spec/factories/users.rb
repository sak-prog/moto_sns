FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User-#{n}" }
    sequence(:email) { |n| "motosns#{n}@example.com" }
    password { "motosns" }
    password_confirmation { "motosns" }
  end
end
