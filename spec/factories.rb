FactoryGirl.define do
  factory :user do
    sequence(:name)     { |n| "Person_#{n}"}
    sequence(:email)    { |n| "Person_#{n}@example.com"}
    sequence(:uid)      { |n| "Person_#{n}"}
      
    factory :admin do
      admin true
    end
  end

  factory :fetch do
    full_fetch true
    user
  end

  factory :article do
    sequence(:item_id)      { |n| n}
    sequence(:word_count)   { |n| n*50}
    sequence(:given_url)    { |n| "http://example#{n}.com" }
    fetch
  end
end

