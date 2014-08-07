require 'spec_helper'

describe Article do

  let(:user)    {FactoryGirl.create(:user)}
  let(:fetch)   {user.fetches.create(full_fetch: false)}
  before do
    @article = fetch.articles.build(
      item_id: 1, 
      word_count: 500, 
      given_url: 'http://test.com'
    )
  end

  subject {@article}

  it {should respond_to(:item_id)}
  it {should respond_to(:given_url)}
  it {should respond_to(:given_title)}
  it {should respond_to(:favorite)}
  it {should respond_to(:status)}
  it {should respond_to(:is_article)}
  it {should respond_to(:word_count)}
  it {should respond_to(:fetch_id)}
  it {should respond_to(:created_at)}
  it {should respond_to(:updated_at)}
  it {should respond_to(:push_id)}
  it {should respond_to(:time_added_pocket)}
  it {should respond_to(:time_updated_pocket)}
  it {should respond_to(:time_read)}
  it {should respond_to(:time_favorited)}
  it {should respond_to(:user_id)}
  its(:fetch) {should eq fetch}
  its(:user) {should eq user}

  it {should be_valid}

  describe "when item_id is not present" do
    before {@article.item_id=nil}
    it {should_not be_valid}
  end

  describe "when fetch_id is not present" do
    before {@article.fetch_id=nil}
    it {should_not be_valid}
  end

  describe "when two articles have the same item_id" do
    before do
      @first_art=fetch.articles.create(item_id: 1, word_count: 500, given_url: 'test', fetch: fetch)
      @secnd_art=fetch.articles.build(item_id: 1, word_count: 500, given_url: 'test', fetch: fetch)
      @secnd_art.item_id=@first_art.item_id
    end
    specify{expect(@secnd_art).not_to be_valid}
  end
end
