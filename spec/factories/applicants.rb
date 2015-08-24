FactoryGirl.define do
  factory :applicant do
    first_name "MyString"
    last_name "MyString"
    region 'San Francisco Bay Area'
    sequence :phone do |n|
        "#{n}#{n}#{n}-123-4567"
    end
    sequence :email do |n|
        "person#{n}@example.com"
    end
    phone_type 'iPhone 6/6 Plus'
    source "MyString"
    over_21 false
    reason "MyText"
    workflow_state 'applied'
  end
end
