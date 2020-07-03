class CreateTrialUserRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :trial_user_relations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :clinic_trial, null: false, foreign_key: true

      t.timestamps
    end
  end
end
