require 'spec_helper'

describe 'User Pages' do

  subject {page}

  describe "signup page" do
    before {visit signup_path}

    let(:submit) {"Sign up"}

    it {should have_title("Sign up")}

    describe "with invalid information" do
      it "should not create a user" do
        expect {click_button submit}.not_to change(User, :count)
      end

      describe "after submission" do
        before {click_button submit}

        it {should have_title('Sign up')}
        it {should have_content('error')}
      end

      describe "with Pocket failure" do
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:pocket] = :invalid_credentials

        before do
          fill_in "Name",      with: "Example Name"
          fill_in "Email",     with: "example@test.com"
          click_button submit
        end
        
        it {should have_title('Sign up')}
        it {should have_content('error')}
        
      end

    end

    describe "with valid information" do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:pocket] = OmniAuth::AuthHash.new({provider: 'pocket', uid: '123'})
      before do
        fill_in "Name",               with: "Example User"
        fill_in "Email",              with: "example@test.com"
      end

      it "should create a new user" do
        expect {click_button submit}.to change(User, :count).by(1)
      end
    end
  end

end
