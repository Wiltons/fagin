require 'spec_helper'

describe Fetch do

  let(:user) {FactoryGirl.create(:user)}

  before do
    @fetch = user.fetches.build(
      full_fetch: false
    )
  end

  subject {@fetch}

  it {should respond_to(:user)}
  it {should respond_to(:full_fetch)}
  its(:user) {should eq user}

  describe "when user_id is not present" do
    before {@fetch.user_id=nil}
    it {should_not be_valid}
  end

  describe "when full_fetch is not present" do
    before {@fetch.full_fetch=nil}
    it {should_not be_valid}
  end

  describe "articles association" do
    before {@fetch.save}
    let(:article) {FactoryGirl.create(:article, fetch: @fetch)}
  end
end
