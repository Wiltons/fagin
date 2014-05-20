require 'spec_helper'

describe "Pushing Pages" do

  let(:user) {FactoryGirl.create(:user)}
  before do
    visit root_path
    sign_in user
  end

  subject {page}

  describe "push page" do
    before {visit push_path}
    it {should have_title('Push')}
    it {should have_content('Push updates to Pocket')}

    it "should have a quick-tag" do
      expect(page).to have_selector(:button, 'Tag long articles')
    end
  end
end
