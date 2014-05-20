require 'spec_helper'

describe Article do

  let(:user)  {FactoryGirl.create(:user)}
  let(:fetch) {FactoryGirl.create(:full_fetch, user: user)}

end
