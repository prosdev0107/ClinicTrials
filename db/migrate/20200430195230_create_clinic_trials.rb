class CreateClinicTrials < ActiveRecord::Migration[6.0]
  def change
    create_table :clinic_trials do |t|
      t.string :upidnumber
      t.string :trial_name
      t.string :trial_status
      t.boolean :bf_status, :default=>false

      t.timestamps
    end
  end
end
