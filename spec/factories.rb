FactoryGirl.define do
  factory :user do
    sequence(:name)     { |n| "Person_#{n}"}
    sequence(:email)    { |n| "Person_#{n}@example.com"}
    sequence(:uid)      { |n| "Person_#{n}"}
      
    factory :admin do
      admin true
    end

    factory :pocketUser do
      uid '123'
    end
  end

  factory :fetch do
    full_fetch false
    user
  end

  factory :article do
    sequence(:item_id)      { |n| n }
    sequence(:given_url)    { |n| "http://example#{n}.com" }
    sequence(:given_title)  { |n| "Article #{n}" }
    favorite  0
    status  0
    word_count 500
    fetch
  end

  factory :push do
    sequence(:article_length) { |n| n }
  end
end

