class ClinicTrialsController < ApplicationController
  def index
    @trials = ClinicTrial.where(bf_status: true).order(:id).page params[:page]
  end

  def show
    unless params[:id].present? 
      redirect_to "index"
    end

    @trial_detail = ClinicalTrialApi.new.fetch_detail(params[:id])
  end

  def register_patient
  end
end
