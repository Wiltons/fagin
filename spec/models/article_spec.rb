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
  
  subject { @article }
  it {should respond_to(:item_id)}
  it {should respond_to(:given_url)}
  it {should respond_to(:favorite)}
  it {should respond_to(:given_title)}
  it {should respond_to(:fetch_id)}
  its(:fetch) {should eq fetch}

  describe "when fetch_id is not present" do
    before {@article.fetch_id=nil}
    it {should_not be_valid}
  end

  describe "with fetch_id present" do
    it "should relate to the current user" do
      expect(@article.fetch.user).to eq user
    end
  end

  describe "when item_id is not present" do
    before {@article.item_id=nil}
    it {should_not be_valid}
  end

end
