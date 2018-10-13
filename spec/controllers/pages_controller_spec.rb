require "rails_helper"

RSpec.describe PagesController, :type => :controller do
  describe "GET landing" do
    it "renders the landing template" do
      get :landing
      expect(response.status).to eq(200)
    end
  end
  describe "GET about" do
    it "renders the about template" do
      get :about
      expect(response.status).to eq(200)
    end
  end
  describe "GET contact" do
    it "renders the contact template" do
      get :contact
      expect(response.status).to eq(200)
    end
  end
end
