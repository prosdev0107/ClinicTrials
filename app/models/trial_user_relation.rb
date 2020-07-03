#Model for trial - user relation (when user apply to the trials, it will be created.)

class TrialUserRelation < ApplicationRecord
  belongs_to :user
end
