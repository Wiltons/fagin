require 'spec_helper'

describe Push, :type => :model do

  let(:user) {FactoryGirl.create(:user)}

  before {@push=user.pushes.build(article_length: 100, source_tag_name: 'source',
                                  destination_tag_name: 'dest')}
  subject {@push}

  it {should respond_to(:articles)}
  it {should respond_to(:article_length)}
  it {should respond_to(:source_tag_name)}
  it {should respond_to(:destination_tag_name)}
  its(:user) {should eq user}

  describe "when user_id is not present" do
    before {@push.user_id=nil}
    it {should_not be_valid}
  end

  describe "when article length is not present" do
    before {@push.article_length=nil}
    it {should_not be_valid}
  end

  describe ".for destination_tag_name" do
    let(:source_tag_name) { 'source' }
    let(:destination_tag_name) { 'dest' }
    let(:article_length) { 100 }
    let(:user_id) { user.id }

    context "when the push already exists" do
      let!(:existing_push) do
        FactoryGirl.create( :push, user_id: user_id, article_length: article_length, 
                            destination_tag_name: destination_tag_name, 
                            source_tag_name: source_tag_name)
      end
    end
  end
end
