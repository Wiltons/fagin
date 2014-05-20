require 'spec_helper'

describe Article do

  let(:user)  {FactoryGirl.create(:user)}
  let(:fetch) {FactoryGirl.create(:fetch, user: user)}

  before do
    @article = fetch.articles.build( 
      item_id: 1, 
      given_url: "http://example.com",
      favorite: false, word_count: 100,
      given_title: "Test article"
    )
  end
  
end
