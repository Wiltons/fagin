require 'spec_helper'
require 'fakeweb'

describe Article do

  before do
    body = "{\"status\":1,
      \"complete\":1,
      \"list\":
      {\"237938806\":
        {\"item_id\":\"237938806\",
        \"resolved_id\":\"237938806\",
        \"given_url\":\"http:\\/\\/getpocket.com\\/developer\\/docs\\/v3\\/retrieve\",
        \"given_title\":\"\",
        \"favorite\":\"0\",
        \"status\":\"0\",
        \"time_added\":\"1400690783\",
        \"time_updated\":\"1400703984\",
        \"time_read\":\"0\",
        \"time_favorited\":\"0\",
        \"sort_id\":0,
        \"resolved_title\":\"Retrieve\",
        \"resolved_url\":\"http:\\/\\/getpocket.com\\/developer\\/docs\\/v3\\/retrieve\",
        \"excerpt\":\"Pocket's \\/v3\\/get endpoint is a single call that is incredibly versatile. A few examples of the types of requests you can make: In order to use the \\/v3\\/get endpoint, your consumer key must have the \\\"Retrieve\\\" permission.\",
        \"is_article\":\"1\",
        \"is_index\":\"0\",
        \"has_video\":\"0\",
        \"has_image\":\"0\",
        \"word_count\":\"855\"}
      }
    }"
    FakeWeb.register_uri(:post, "https://getpocket.com/v3/get", body: body)
  end

  let(:user)    {FactoryGirl.create(:user)}
  let(:fetch)   {FactoryGirl.create(:fetch, user: user)}
  before do
    raise fetch.to_yaml
    @article = fetch.articles.build(item_id: 1, word_count: 500, given_url: 'http://test.com', fetch_id: fetch.id)
  end

  subject {@article}

  before do
    raise "#{user.to_yaml}, #{fetch.to_yaml}, #{@article.to_yaml}"
  end

  it {should respond_to(:item_id)}
  it {should respond_to(:given_url)}
  it {should respond_to(:given_title)}
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

end
