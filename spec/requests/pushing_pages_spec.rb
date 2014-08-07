require 'spec_helper'

describe "Pushing Pages" do

  let(:user) {FactoryGirl.create(:user)}
  before do
    visit root_path
    sign_in user
  end

  subject {page}

  describe "create page" do
    before {visit new_push_path}
    it {should have_title('New Rule')}
    it {should have_content('I want to tag')}
    it {should have_button('Save')}
    it {should have_button('Save and Run')}
    it {should have_button('Save and Create New')}
  end

  describe "index page" do
    before {visit pushes_path}
    it {should have_title('All Rules')}
    it {should have_content('All Rules')}
# Implement FactoryGirl for creating taggers
    it {should have_selector('div.pagination')}
    it {should have_link('Run')}
    #it {should have_button('Edit')}
    it {should have_link('Delete')}
  end
end
