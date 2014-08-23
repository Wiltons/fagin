require 'spec_helper'

describe "Static pages", :type => :request do
  before(:each) do
    fake_one_article
  end

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    expect(page).to have_title(full_title(''))
    click_link "Fagin"
    expect(page).to have_title(full_title(''))
  end

  describe "Home page" do
    before { visit root_path }

    let(:heading)	{ 'Fagin' }
    let(:page_title)	{ '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) {FactoryGirl.create(:user)}
      before do
        sign_in user
        visit root_path
      end

      #it {should have_content('view my profile')}
      
      it "should have populate links" do
        expect(page).to have_selector(:button, 'Fetch Pocket Articles')
      end

      describe "fetching articles" do
        it "should create a fetch and article" do
          expect{click_button 'Fetch Pocket Articles' }.to change(Article, :count).by(1)
          expect{click_button 'Fetch Pocket Articles' }.to change(Fetch, :count).by(1)
        end

        it "should not double-save articles on a full fetch with no new articles" do
          expect{click_button 'Fetch Pocket Articles' }.to change(Article, :count).by(1)
          find(:xpath, "/html/body/div/div/form/input[2]").set(true)
          expect{click_button 'Fetch Pocket Articles' }.not_to change(Article, :count)
        end

        it "should save a new article on a full fetch with new articles" do
          expect{click_button 'Fetch Pocket Articles' }.to change(Article, :count).by(1)
          find(:xpath, "/html/body/div/div/form/input[2]").set(true)
          fake_new_article
          expect{click_button 'Fetch Pocket Articles' }.to change(Article, :count).by(1)
        end

        it "should not do anything on partial fetch with no new articles" do
          expect{click_button 'Fetch Pocket Articles' }.to change(Article, :count).by(1)
          find(:xpath, "/html/body/div/div/form/input[2]").set(false)
          expect{click_button 'Fetch Pocket Articles' }.not_to change(Article, :count)
        end

        it "should save a new article on a partial fetch" do
          expect{click_button 'Fetch Pocket Articles' }.to change(Article, :count).by(1)
          find(:xpath, "/html/body/div/div/form/input[2]").set(false)
          fake_new_article
          expect{click_button 'Fetch Pocket Articles' }.to change(Article, :count).by(1)
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    let(:heading)	{ 'Help' }
    let(:page_title)	{ 'Help' }
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    let(:heading)	{ 'About' }
    let(:page_title)	{ 'About' }
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    let(:heading)	{ 'Contact' }
    let(:page_title)	{ 'Contact' }
    it_should_behave_like "all static pages"
  end
end
