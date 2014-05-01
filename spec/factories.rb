FactoryGirl.define do
  factory :user do
    sequence(:name)     { |n| "Person_#{n}"}
    sequence(:email)    { |n| "Person_#{n}@example.com"}
    sequence(:uid)      { |n| "Person_#{n}"}
      
    factory :admin do
      admin true
    end
  end

  factory :article do
    item_id     1
    word_count  500
    given_url   "http://example.com"
    user
  end
end

