require 'spec_helper'

describe "Pushing Pages" do

  let(:user) {FactoryGirl.create(:user)}
  before do
    visit root_path
    sign_in user
  end

  subject {page}

  describe "create page" do
    before {visit push_path}
    it {should have_title('Create')}
    it {should have_content('Create a new Tagger')}
    it {should have_button('Save')}
    it {should have_button('Save and run')}
    it {should have_button('Save and create new')}
  end

  describe "index page" do
    before {visit pushes_path}
    it {should have_title('Manage')}
    it {should have_content('Manage existing taggers')}
# Implement FactoryGirl for creating taggers
    it {should have_selector('div.pagination')}
    it {should have_button('Run')}
    it {should have_button('Edit')}
    it {should have_button('Delete')}
  end
end
