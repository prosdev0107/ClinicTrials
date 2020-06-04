class ClinicTrial < ApplicationRecord
  validates :bf_status, :is_new, inclusion: { in: [true, false] }
end
