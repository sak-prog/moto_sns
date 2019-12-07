FactoryBot.define do
  factory :post do
    sequence(:content) { |n| "test-#{n}" }
    user
  end
end
