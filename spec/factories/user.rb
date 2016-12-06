FactoryGirl.define do
  factory :user do
    # id nil
    association :company
    sequence(:name) { |n| "user-#{n}" }
    sequence(:email) { |n| "user-#{n}@email.com" }
  end
end
