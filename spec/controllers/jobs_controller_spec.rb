require 'rails_helper'

RSpec.describe JobsController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to be_success
    end
  end

  describe "GET format" do
    it "returns http success" do
      get :format
      expect(response).to be_success
    end
  end

end
