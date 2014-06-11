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
  it {should respond_to(:tag_relationships)}
  its(:fetch) {should eq fetch}

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
