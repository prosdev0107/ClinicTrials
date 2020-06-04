class AddIsNewToClinicTrials < ActiveRecord::Migration[6.0]
  def change
    add_column :clinic_trials, :is_new, :boolean
  end
end
