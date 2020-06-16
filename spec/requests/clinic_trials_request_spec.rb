require 'rails_helper'

RSpec.describe "ClinicTrials", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/clinic_trials/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/clinic_trials/show"
      expect(response).to have_http_status(:success)
    end
  end

end
