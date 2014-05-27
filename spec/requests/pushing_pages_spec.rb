require 'spec_helper'

describe "Pushing Pages" do

  subject {page}

  describe "push page" do
    before {visit push_path}
    it {should have_title('Push')}
    it {should have_content('Push updates to Pocket')}
  end

  it "should have a quick-tag" do
    expect(page).to have_selector(:button, 'Tag long articles')
  end

end
