require 'rails_helper'

RSpec.describe "Admin::ClinicTrials", type: :request do
  describe "GET index" do
    before(:each) do
      get '/admin/clinic_trials'
    end

    it "has a 200 status code" do
      expect(response.status).to eq(302)
    end

    it "render index page" do
      expect(response).to render_template(:index)
    end
  end

  describe "#create" do
    before(:each) do
      post '/admin/clinic_trials'
    end

    it "responds to html+charset=utf-8 by default" do
      expect(response.content_type).to eq "text/html; charset=utf-8"
    end

    it "redirect_to admin_path" do
      expect(response).to redirect_to admin_path(:new)
    end
  end
end
