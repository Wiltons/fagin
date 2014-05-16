require 'spec_helper'

describe "Authentication" do

  subject {page}

  describe "signing in" do
    before {visit root_url}

    describe "with a pocket failure" do
      before do
        OmniAuth.config.mock_auth[:pocket] = :invalid_credentials
        click_link 'Sign in with Pocket'
      end
      
      it {should have_title('')}
      it {should have_selector('div.alert.alert-error')}

      describe "on visiting another page" do
        before {visit about_path}

        it {should have_title('About')}
        it {should_not have_selector('div.alert.alert-error')}
      end
    end

    describe "with a successful pocket signin" do
      let(:user) {FactoryGirl.create(:user)}
      before {sign_in user}

      it {should have_selector('div.alert.alert-success')}
      describe "page" do
        it {should have_title("Edit user")}
        it {should have_content("Update your profile")}
        it {should have_link('change', href: 'http://gravatar.com/emails')}
      end

      describe "with signout and signin" do
        before do
          click_link "Sign out"
          sign_in user
        end
        it {should have_content('Last update')}
      end

    end
  end

end
