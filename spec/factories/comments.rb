FactoryBot.define do
  factory :comment do
    content { "a" * 10 }
    association :user
    association :post
  end
end
