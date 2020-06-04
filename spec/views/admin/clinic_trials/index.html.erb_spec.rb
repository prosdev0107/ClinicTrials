require "rails_helper"

RSpec.describe "clinic_trials/index.html.erb", type: :view do
  it "displays all the widgets" do
    assign(:trials, Kaminari.paginate_array([
      ClinicTrial.create!(:upidnumber => 'utc0000', :trial_name => 'Trial1', :trial_status => 'Completed', :is_new => true, :bf_status => true),
      ClinicTrial.create!(:upidnumber => 'utc0001', :trial_name => 'Trial2', :trial_status => 'Not yet', :is_new => true, :bf_status => false)
    ]).page(1))

    render :template => "admin/clinic_trials/index.html.erb"

    expect(rendered).to match /utc0000/
    expect(rendered).to match /utc0001/
  end
end