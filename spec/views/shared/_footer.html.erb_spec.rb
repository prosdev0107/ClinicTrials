require "rails_helper"

RSpec.describe "shared/_footer.html.erb", type: :view do
  it "displays address" do
    render :partial => "shared/footer.html.erb"

    expect(rendered).to match /Address:/
  end
end