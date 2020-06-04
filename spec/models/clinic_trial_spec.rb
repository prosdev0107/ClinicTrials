require 'rails_helper'

RSpec.describe ClinicTrial, type: :model do
  context "when is_new or bf_status is empty" do
    let (:trial_new) { ClinicTrial.new(is_new: true) }
    let (:trial_bf) { ClinicTrial.new(bf_status: true) }

    it 'should not be valid(bf_status is empty)' do
      expect(trial_new.valid?).to be false  
    end

    it 'should not be valid(is_new is empty)' do
      expect(trial_bf.valid?).to be false 
    end
  end

  context "when is_new and bf_status are not empty" do
    let (:trial) { ClinicTrial.new(is_new: true, bf_status: true) }

    it 'should be valid' do
      expect(trial.valid?).to be true
    end

    it 'should be save' do
      expect(trial.save).to be true
    end
  end  
end
