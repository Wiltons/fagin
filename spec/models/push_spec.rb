require 'spec_helper'

describe Push, :type => :model do

  let(:user) {FactoryGirl.create(:user)}

  before {@push=user.pushes.build}
  subject {@push}

  it {should respond_to(:articles)}
  its(:user) {should eq user}
end
