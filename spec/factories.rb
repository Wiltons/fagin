FactoryGirl.define do
  factory :user do
    sequence(:uid)   { |n| "#{n}"}
  end
end
