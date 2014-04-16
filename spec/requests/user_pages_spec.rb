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

      describe "when email doesn't match confirmation" do
        before do
          fill_in "Name",             with: "Example User"
          fill_in "Email",            with: "example@test.com"
          fill_in "Confirm Email",    with: "ex@test.com"
        end

        it "should not create a user" do
          expect {click_button submit}.not_to change(User, :count)
        end

        it {should have_title('Sign up')}
        it {should have_content('error')}
      end

    end

    describe "with valid information" do
      before do
        fill_in "Name",               with: "Example User"
        fill_in "Email",              with: "example@test.com"
        fill_in "Confirm Email",      with: "example@text.com"
      end

      it "should create a new user" do
        expect {click_button submit}.to change(User, :count).by(1)
      end
    end
  end

end
