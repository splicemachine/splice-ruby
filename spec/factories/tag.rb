FactoryGirl.define do
  factory :tag do
    # id nil
    sequence(:name) { |n| "tag-#{n}" }
  end
end
