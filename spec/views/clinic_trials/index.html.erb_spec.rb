require 'rails_helper'

RSpec.describe "clinic_trials/index.html.erb", type: :view do
  it "displays the trials" do
    assign(:ctlist, {:UTCID => 'utc000'})

    render :template => "admin/clinic_trials/show.html.erb"

    expect(rendered).to match /utc000/
  end
end
