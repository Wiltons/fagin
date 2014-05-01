require 'spec_helper'

describe Article do

  let(:user) {FactoryGirl.create(:user)}
  
  before do
    @article = user.articles.build( 
      item_id: 1, 
      given_url: "http://example.com",
      favorite: false, word_count: 100,
      given_title: "Test article")
  end
  
  subject { @article }

  it {should respond_to(:item_id)}
  it {should respond_to(:user_id)}
  it {should respond_to(:given_url)}
  it {should respond_to(:favorite)}
  it {should respond_to(:given_title)}
  it {should respond_to(:word_count)}
  it {should respond_to(:user)}
  its(:user) {should eq user}

  describe "when user_id is not present" do
    before {@article.user_id = nil}
    it {should_not be_valid}
  end

  describe "when item id is not present" do
    before {@article.item_id = nil}
    it {should_not be_valid}
  end

  describe "when item id is not present" do
    before {@article.word_count = nil}
    it {should_not be_valid}
  end

end
