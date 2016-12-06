FactoryGirl.define do
  factory :company do
    # id nil
    sequence(:name) { |n| "company-#{n}" }
  end
end