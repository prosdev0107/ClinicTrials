require "rails_helper"

RSpec.describe "shared/_sidebar.html.erb", type: :view do
  it "displays address" do
    render :partial => "shared/sidebar.html.erb"

    expect(rendered).to match /Show All/
    expect(rendered).to match /Import New/
  end
end