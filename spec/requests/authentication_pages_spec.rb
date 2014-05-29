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
      let(:pocketUser)  {FactoryGirl.create(:pocketUser)}
      before {sign_in user}
      it {should have_selector('div.alert.alert-success')}
      describe "page" do
        it {should have_title("Edit user")}
        it {should have_content("Update your profile")}
        it {should have_link('change', href: 'http://gravatar.com/emails')}
      end

      describe "with signout and signin" do
        before do
          # Settings and Profile tests fail without pocketUser initialization. Don't know why
          # Need to refactor sign_in utility to avoid this incorrect failure
          pocketUser
          click_link "Sign out"
          sign_in pocketUser
        end
        it {should have_content('Last update')}
        it {should have_link('Sign out',  href: signout_path)}
        it {should have_link('Settings',      href: edit_user_path(pocketUser))}
        it {should_not have_link('Sign in',   href: signin_path)}
        it {should have_link('Push',          href: new_push_path)}
        it {should have_link('Profile',       href: user_path(pocketUser))}
      end
    end
  end

  describe "as a non-signed in user" do

    let(:user) {FactoryGirl.create(:user)}
    it {should_not have_link('Push',        href: new_push_path)}
    it {should_not have_link('Profile',     href: user_path(user))}
    it {should_not have_link('Sign out',    href: signout_path)}
    it {should_not have_link('Settings',    href: edit_user_path(user))}

    describe "submitting a GET request to the Push#new action" do
      before {get new_push_path}
      specify {expect(response.body).not_to match(full_title('Push'))}
      specify {expect(response).to redirect_to(root_url)}
    end

    describe "submitting a GET request to the Users#edit action" do
      before {get edit_user_path(user)}
      specify {expect(response.body).not_to match(full_title('Edit user'))}
      specify {expect(response).to redirect_to(root_url)}
    end
  end
end
