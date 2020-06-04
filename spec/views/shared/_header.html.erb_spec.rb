require "rails_helper"

RSpec.describe "shared/_header.html.erb", type: :view do
  it "displays trials' name" do
    render :partial => "shared/header.html.erb"

    expect(rendered).to match /Psoriatic Arthritis/
  end
end