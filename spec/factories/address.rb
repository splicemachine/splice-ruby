FactoryGirl.define do
  factory :address do
    # id nil
    sequence(:street_name)  { |n| n.to_s }
    sequence(:street_number) { |n| "Street#{n}" }
    city 'New York'
    country 'USA'
  end
end
