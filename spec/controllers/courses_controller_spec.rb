require "rails_helper"

RSpec.describe CoursesController, :type => :controller do
  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  pending "GET #show"
end
